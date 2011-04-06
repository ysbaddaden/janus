class Janus::PasswordsController < ApplicationController
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.find_for_database_authentication(params[:user])
    
    if @user
      @user.generate_reset_password!
#      JanusMailer.reset_password(@user).deliver
      
      respond_to do |format|
        format.html { redirect_to root_url, :notice => t('flash.janus.passwords.create.email_sent') }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_password_url, :alert => t('flash.janus.passwords.create.user_not_found') }
        format.any  { head :precondition_failed }
      end
    end
  end

  def edit
    @user = User.find_for_password_reset(params[:token])
    redirect_to root_url, :alert => t('flash.janus.passwords.edit.alert') unless @user
  end

  def update
    @user = User.find_for_password_reset(params[:user][:reset_password_token])
    
    if @user
      if @user.reset_password!(params[:user])
        respond_to do |format|
          format.html { redirect_to root_url, :notice => t('flash.janus.passwords.update.password_updated') }
          format.any  { head :ok }
        end
      else
        respond_to do |format|
          format.html { render 'edit' }
          format.any  { head :precondition_failed }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_url, :alert => t('flash.janus.passwords.update.invalid_token') }
        format.any  { head :precondition_failed }
      end
    end
  end
end
