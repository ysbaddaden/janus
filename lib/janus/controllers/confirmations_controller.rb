# This controller is responsible for confirming any user email. It's also
# responsible for resending the confirmation email on demand by the user.
class Janus::ConfirmationsController < ApplicationController
  include Janus::InternalHelpers

  helper JanusHelper

  def show
    self.resource = resource_class.find_for_confirmation(params[resource_class.confirmation_key])

    if resource
      resource.confirm!

      respond_to do |format|
        format.html { redirect_to root_url, :notice => t('flash.janus.confirmations.edit.confirmed') }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          self.resource = resource_class.new
          resource.errors.add(:base, :invalid_token)
          render 'new'
        end

        format.any { head :bad_request }
      end
    end
  end

  def new
    self.resource = resource_class.new
    respond_with(resource)
  end

  def create
    self.resource = resource_class.find_for_database_authentication(params[resource_name])

    if resource
      deliver_confirmation_instructions

      respond_to do |format|
        format.html { redirect_to root_url, :notice => t('flash.janus.confirmations.create.email_sent') }
        format.any  { head :ok }
      end
    else
      respond_to do |format|
        format.html do
          self.resource = resource_class.new
          resource.errors.add(:base, :not_found)
          render 'new'
        end

        format.any { head :not_found }
      end
    end
  end

  # Simple wrapper for Mailer#confirmation_instructions.deliver to
  # allow customization of the email (eg: to pass additional data).
  def deliver_confirmation_instructions
    mailer_class.confirmation_instructions(resource).deliver
  end
end
