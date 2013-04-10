# This controller is responsible for resetting a lost password. It sends an
# email with an unique token, on demand by the user. Then allows the user to
# change its password (as long as the token is valid).
class Janus::PasswordsController < ApplicationController
  include Janus::InternalHelpers

  helper JanusHelper

  def new
    self.resource = resource_class.new
  end

  def create
    self.resource = resource_class.find_for_database_authentication(params[resource_name])

    if resource
      resource.generate_reset_password_token!
      mailer_class.reset_password_instructions(resource).deliver

      respond_to do |format|
        format.html { redirect_to root_url, :notice => t('flash.janus.passwords.create.email_sent') }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          self.resource = resource_class.new
          resource.errors.add(:base, :not_found)
          render "new"
        end
        format.any { head :precondition_failed }
      end
    end
  end

  def edit
    self.resource = resource_class.find_for_password_reset(params[:token])
    redirect_to root_url, :alert => t('flash.janus.passwords.edit.alert') unless resource
  end

  def update
    self.resource = resource_class.find_for_password_reset(params[resource_name][:reset_password_token])

    if resource
      if resource.reset_password!(params[resource_name])
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
