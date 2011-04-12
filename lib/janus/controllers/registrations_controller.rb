class Janus::RegistrationsController < ApplicationController
  helper JanusHelper

  before_filter      :authenticate_user!, :except => [:new, :create]
  skip_before_filter :authenticate_user!, :only   => [:new, :create]

  def new
    @user = User.new
    respond_with(@user)
  end

  def edit
    @user = current_user
    respond_with(@user)
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      janus.login(@user, :rememberable => true)
    else
      @user.clean_up_passwords
    end
    
    respond_with(@user, :location => after_sign_up_url(@user))
  end

  def update
    params[:user].each do |key, value|
      params[:user].delete(key) if value.blank? && [:password, :password_confirmation].include?(key.to_sym)
    end
    
    @user = current_user
    @user.current_password = ""
    @user.clean_up_passwords unless @user.update_attributes(params[:user])
    respond_with(@user, :location => after_sign_up_url(@user))
  end

  def destroy
    @user = current_user
    janus.unset_user(:user) if @user.destroy
    
    respond_with(@user) do |format|
      format.html { redirect_to root_url }
    end
  end

  def after_sign_up_url(user)
    user
  end
end
