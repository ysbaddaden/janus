class Janus::ConfirmationsController < ApplicationController
  helper JanusHelper

  def show
    @user = User.find_for_confirmation(params[User.confirmation_key])
    
    if @user
      @user.confirm!
      
      respond_to do |format|
        format.html { redirect_to root_url, :notice => t('flash.janus.confirmations.edit.confirmed') }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          @user = User.new
          @user.errors.add(:base, :invalid_token)
          render 'new'
        end
        
        format.any { head :bad_request }
      end
    end
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def create
    @user = User.find_for_database_authentication(params[:user])
    
    if @user
      JanusMailer.confirmation_instructions(@user).deliver
      
      respond_to do |format|
        format.html { redirect_to root_url, :notice => t('flash.janus.confirmations.create.email_sent') }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          @user = User.new
          @user.errors.add(:base, :not_found)
          render 'new'
        end
        
        format.any { head :not_found }
      end
    end
  end
end
