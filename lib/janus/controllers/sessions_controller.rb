require 'addressable/uri'

class Janus::SessionsController < ApplicationController
  helper JanusHelper
  skip_before_filter :authenticate_user!

  def new
    if user_signed_in?
      redirect_after_sign_in(current_user)
    else
      @user = User.new
      respond_with(@user)
    end
  end

  def create
    @user = User.find_for_database_authentication(params[:user])
    
    if @user && @user.valid_password?(params[:user][:password])
      janus.login(@user, :rememberable => params[:remember_me])
      
      respond_to do |format|
        format.html { redirect_after_sign_in(@user) }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          @user ||= User.new(params[:user])
          @user.clean_up_passwords
          @user.errors.add(:base, :not_found)
          
          render "new", :status => :unauthorized
        end
        format.any { head :unauthorized }
      end
    end
  end

  def destroy
    janus.logout(:user)
    
    respond_to do |format|
      format.html { redirect_to after_sign_out_url(:user) }
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

  private
    # Either redirects the user to after_sign_in_url or to
    # <tt>params[:return_to]</tt>. If params[:return_to] is an URL --and not
    # just a path-- valid_remote_host? will be invoked to check if we should
    # redirect to this URL or not.
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
