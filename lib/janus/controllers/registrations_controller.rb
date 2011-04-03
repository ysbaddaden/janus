class Janus::RegistrationsController < ApplicationController
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
    janus.login(@user) if @user.save
    respond_with(@user, :location => after_sign_up_url(@user))
  end

  def update
    @user = current_user
    @user.current_password = ""
    @user.update_attributes(params[:user])
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
