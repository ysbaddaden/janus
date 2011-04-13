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
    self.resource = resource_class.new(params[resource_name])
    
    if resource.save
      janus.login(resource, :scope => janus_scope, :rememberable => true)
      JanusMailer.confirmation_instructions(resource).deliver if resource.respond_to?(:confirm!)
    else
      resource.clean_up_passwords
    end
    
    respond_with(resource, :location => after_sign_up_url(resource))
  end

  def update
    params[resource_name].each do |key, value|
      params[resource_name].delete(key) if value.blank? && [:password, :password_confirmation].include?(key.to_sym)
    end
    
    self.resource = send("current_#{janus_scope}")
    resource.current_password = ""
    resource.clean_up_passwords unless resource.update_attributes(params[resource_name])
    respond_with(resource, :location => after_sign_up_url(resource))
  end

  def destroy
    self.resource = send("current_#{janus_scope}")
    janus.unset_user(janus_scope) if resource.destroy
    
    respond_with(resource) do |format|
      format.html { redirect_to root_url }
    end
  end

  def after_sign_up_url(user)
    user
  end
end
