# This controller is responsible for confirming any user email. It's also
# responsible for resending the confirmation email on demand by the user.
class Janus::ConfirmationsController < ApplicationController
  include Janus::InternalHelpers

  helper JanusHelper

  before_filter :load_resource_from_confirmation_token, :only => :show
  before_filter :load_resource_from_authentication_params, :only => :create

  def show
    resource.confirm!

    respond_with_success do
      redirect_to after_confirmation_url(resource),
        notice: t('flash.janus.confirmations.edit.confirmed')
    end
  end

  def new
    self.resource = resource_class.new
    respond_with(resource)
  end

  def create
    deliver_confirmation_instructions(resource)

    respond_with_success do
      redirect_to after_resending_confirmation_instructions_url(resource),
        notice: t('flash.janus.confirmations.create.email_sent')
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

  private

  def load_resource_from_confirmation_token
    token = params[resource_class.confirmation_key]
    self.resource = resource_class.find_for_confirmation(token)
    respond_with_failure(:invalid_token, :status => :bad_request) unless resource
  end

  def load_resource_from_authentication_params
    self.resource = resource_class.find_for_database_authentication(resource_authentication_params)
    respond_with_failure(:not_found) unless resource
  end
end
