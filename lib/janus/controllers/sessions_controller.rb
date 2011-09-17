require 'addressable/uri'

class Janus::SessionsController < ApplicationController
  include Janus::InternalHelpers
#  include Janus::UrlHelpers

  helper JanusHelper
#  skip_before_filter :authenticate_user!

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
    self.resource = resource_class.find_for_database_authentication(params[resource_name])
    
    if resource && resource.valid_password?(params[resource_name][:password])
      janus.login(resource, :scope => janus_scope, :rememberable => params[:remember_me])
      
      respond_to do |format|
        format.html { redirect_after_sign_in(resource) }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          self.resource ||= resource_class.new(params[resource_name])
          resource.clean_up_passwords
          resource.errors.add(:base, :not_found)
          
          render "new", :status => :unauthorized
        end
        format.any { head :unauthorized }
      end
    end
  end

  def destroy
    janus.logout(janus_scope)
    
    respond_to do |format|
      format.html { redirect_to after_sign_out_url(janus_scope) }
      format.any  { head :ok }
    end
  end

  def after_sign_in_url(user)
    user
  end

  def after_sign_out_url(scope)
    root_url
  end

  # Returns true if remote host is known and redirect with an auth_token should
  # be allowed or not. It must be overwritten by child class since it always
  # returns true by default.
  def valid_remote_host?(host)
    true
  end

  # Either redirects the user to after_sign_in_url or to
  # <tt>params[:return_to]</tt>. If return_to is an absolute URL, and not just
  # a path, valid_remote_host? will be invoked to check if we should redirect
  # to this URL or not --which is moslty of use for RemoteAuthenticatable to
  # securize auth tokens from unknown domains.
  def redirect_after_sign_in(user)
    unless params[:return_to].blank?
      return_to = Addressable::URI.parse(params[:return_to])
      
      if return_to.host.nil? || return_to.host == request.host
        redirect_to params[:return_to]
        return
      elsif valid_remote_host?(return_to.host)
        if user.class.include?(Janus::Models::RemoteAuthenticatable)
          query = return_to.query_values || {}
          return_to.query_values = query.merge(user.class.remote_authentication_key => user.generate_remote_token!)
        end
        
        redirect_to return_to.to_s
        return
      end
    end
    
    redirect_to after_sign_in_url(user)
  end
end
