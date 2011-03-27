class Janus::SessionsController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    @user = User.new
    respond_with(@user)
  end

  def create
    @user = User.find_for_database_authentication(params[:user])
    
    if @user && @user.valid_password?(params[:user][:password])
      janus.login(@user)
      
      respond_to do |format|
        format.html { redirect_to after_sign_in_url(@user) }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          @user ||= User.new(params[:user])
          @user.clean_up_passwords
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
end
