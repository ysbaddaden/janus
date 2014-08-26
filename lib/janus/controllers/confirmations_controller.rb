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
        format.html do
          redirect_to after_confirmation_url(resource),
            :notice => t('flash.janus.confirmations.edit.confirmed')
        end

        format.any { head :ok }
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
    self.resource = resource_class.find_for_database_authentication(resource_authentication_params)

    if resource
      deliver_confirmation_instructions(resource)

      respond_to do |format|
        format.html do
          redirect_to after_resending_confirmation_instructions_url(resource),
            :notice => t('flash.janus.confirmations.create.email_sent')
        end

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
  def deliver_confirmation_instructions(resource)
    mailer_class.confirmation_instructions(resource).deliver
  end

  # Where to redirect after the instructions have been sent.
  def after_resending_confirmation_instructions_url(resource)
    root_url
  end

  # Where to redirect when the user has confirmed her account.
  def after_confirmation_url(resource)
    root_url
  end
end
