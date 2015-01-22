require 'addressable/uri'

# This controller is responsible for creating and destroying user sessions.
#
# The creation uses the DatabaseAuthenticatable strategy, while the destruction
# simply destroys any session, whatever strategy it was created with. Janus
# hooks will be called, allowing to destroy any Rememberable cookies as well as
# any user defined behavior.
#
class Janus::SessionsController < ApplicationController
  include Janus::InternalHelpers

  helper JanusHelper

  before_filter :load_resource_from_authentication_params, :only => :create

  def new
    params[:return_to] ||= request.env["HTTP_REFERER"]

    if signed_in?(janus_scope)
      redirect_after_sign_in(send("current_#{janus_scope}"))
    else
      self.resource = resource_class.new
      respond_with(resource)
    end
  end

  def create
    if valid_resource?
      janus.login(resource, :scope => janus_scope, :rememberable => params[:remember_me])
      respond_with_success { redirect_after_sign_in(resource) }
    else
      respond_with_failure :not_found, :status => :unauthorized
    end
  end

  def destroy
    janus.logout(janus_scope)
    respond_with_success { redirect_to after_sign_out_url(janus_scope) }
  end

  # An overridable method that returns the default path to return the just
  # signed in user to. Defaults to return the user object, which will be
  # interpreted by rails as `user_path(user)`.
  def after_sign_in_url(user)
    user
  end

  # An overridable method that returns the default path to return the just
  # signed out user to. Defaults to `root_url`.
  def after_sign_out_url(scope)
    root_url
  end

  # Returns true if host is request.host. You may want to overwrite this method
  # to check if a user can access the current host and return false otherwise.
  #
  # For instance when a user signed in from a subdomain she can't access, and
  # you want to redirect her to another subdomain.
  def valid_host?(host)
    host == request.host
  end

  # Must return true if host is known and we allow to redirect the user
  # with an auth_token.
  #
  # Warning: must be overwritten by child classes because it always
  # returns false by default!
  def valid_remote_host?(host)
    false
  end

  # Returns an Array of URL that we shouldn't automatically return to. It
  # actually returns URL to prevent infinite loops. We must for instance
  # never return to new_sesssion_path.
  #
  # If you ever need to override this method, don't forget to call `super`.
  # For instance:
  #
  #   def never_return_to(scope)
  #     super + [ my_peculiar_path, another_path ]
  #   end
  #
  def never_return_to(scope)
    scope = Janus.scope_for(scope)
    list = [new_session_path(scope)]

    begin
      list + [
        destroy_session_path(scope),
        new_password_path(scope),
        edit_password_path(scope)
      ]
    rescue NoMethodError
      list
    end
  end

  # Either redirects the user to after_sign_in_url or to <tt>params[:return_to]</tt>.
  #
  # If <tt>params[:return_to] is an absolute URL, and not just a path,
  # valid_remote_host? will be invoked to check wether we should redirect
  # to this URL or not, in order to secure auth tokens for
  # RemoteAuthenticatable to leak into the wild.
  def redirect_after_sign_in(user)
    if params[:return_to].present?
      return_to = Addressable::URI.parse(params[:return_to])

      unless never_return_to(user).include?(return_to.path)
        # path or same host redirection
        if valid_host?(return_to.host || request.host)
          redirect_to params[:return_to] and return
        end

        # external host redirection
        if valid_remote_host?(return_to.host)
          add_remote_authentication_key(return_to, user) if user.class.include?(Janus::Models::RemoteAuthenticatable)
          redirect_to return_to.to_s and return
        end
      end
    end

    redirect_to after_sign_in_url(user)
  end

  def add_remote_authentication_key(return_to, user)
    query = return_to.query_values || {}
    return_to.query_values = query.merge(
      user.class.remote_authentication_key => user.generate_remote_token!
    )
  end

  private

  def valid_resource?
    resource && resource.valid_password?(params[resource_name][:password])
  end

  def initialize_resource
    resource_class
      .new(resource_authentication_params)
      .tap(&:clean_up_passwords)
  end

  def load_resource_from_authentication_params
    self.resource = resource_class.find_for_database_authentication(resource_authentication_params)
    respond_with_failure :not_found, :status => :unauthorized unless resource
  end
end
