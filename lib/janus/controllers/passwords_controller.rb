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
      deliver_reset_password_instructions

      respond_to do |format|
        format.html do
          redirect_to after_sending_reset_password_instructions_url(resource),
            :notice => t('flash.janus.passwords.create.email_sent')
        end
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
          format.html { redirect_after_password_change(self.resource, :notice => t('flash.janus.passwords.update.password_updated')) }
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

  # Simple wrapper for Mailer#reset_password_instructions.deliver to
  # allow customization of the email (eg: to pass additional data).
  def deliver_reset_password_instructions
    mailer_class.reset_password_instructions(resource).deliver
  end

  # Either redirects the user to after_password_change_url or to
  # <tt>params[:return_to]</tt> if present.
  def redirect_after_password_change(resource, options = {})
    if params[:return_to].present?
      redirect_to params[:return_to], options
    else
      redirect_to after_password_change_url(resource), options
    end
  end

  # Where to redirect when the password has been changed.
  def after_password_change_url(resource)
    root_url
  end

  # Where to redirect when the instructions have been sent.
  def after_sending_reset_password_instructions_url(resource)
    root_url
  end
end
