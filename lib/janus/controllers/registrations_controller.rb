class Janus::RegistrationsController < ApplicationController
  include Janus::InternalHelpers

  helper JanusHelper

  before_filter      :authenticate!, :except => [:new, :create]
  skip_before_filter :authenticate!, :only   => [:new, :create]

  def new
    self.resource = resource_class.new
    respond_with(resource)
  end

  def edit
    self.resource = send("current_#{janus_scope}")
    respond_with(resource)
  end

  def create
    self.resource = resource_class.new(send("#{janus_scope}_params"))

    if resource.save
      janus.login(resource, :scope => janus_scope, :rememberable => true)
      deliver_confirmation_instructions(resource) if resource.respond_to?(:confirm!)
    else
      resource.clean_up_passwords
    end

    respond_with(resource, :location => after_sign_up_url(resource))
  end

  def update
    self.resource = send("current_#{janus_scope}")
    resource.current_password = ""
    resource.clean_up_passwords unless resource.update_attributes(resource_params)
    respond_with(resource, :location => after_sign_up_url(resource))
  end

  def destroy
    self.resource = send("current_#{janus_scope}")
    janus.unset_user(janus_scope) if resource.destroy

    respond_with(resource) do |format|
      format.html { redirect_to after_destroy_url(resource) }
    end
  end

  # Simple wrapper for Mailer#confirmation_instructions.deliver to
  # allow customization of the email (eg: to pass additional data).
  def deliver_confirmation_instructions(resource)
    mail = mailer_class.confirmation_instructions(resource)
    mail.respond_to?(:deliver_later) ? mail.deliver_later : mail.deliver
  end

  # Where to redirect after user has registered.
  def after_sign_up_url(user)
    user
  end

  # Where to redirect after user has unregistered.
  def after_destroy_url(resource)
    root_url
  end

  def resource_params
    keys = %w{current_password password password_confirmation}
    send("#{janus_scope}_params").reject do |key, value|
      value.blank? and keys.include?(key)
    end
  end
end
