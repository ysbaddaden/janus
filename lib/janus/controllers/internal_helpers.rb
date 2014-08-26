module Janus
  # A collection of abstraction helper methods used in Janus controllers and views.
  # This should be of no particular outside of abstract controllers for Janus that
  # must be working for all scopes at once.
  module InternalHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :janus_scope, :resource, :resource_class, :resource_name
    end

    # Abstract method for the authenticate_scope! before filter, with scope
    # as detected by janus_scope.
    def authenticate!
      send("authenticate_#{janus_scope}!")
    end

    # Detects the scope from the controller name.
    def janus_scope
      @janus_scope ||= self.class.name.split('::', 2).first.underscore.singularize
    end

    # Returns the `@user` instance variable (or `@admin` or whatever),
    # as detected by janus_scope.
    def resource
      instance_variable_get(:"@#{janus_scope}")
    end

    # Sets the `@user` instance variable (or `@admin` or whatever),
    # as detected by janus_scope.
    def resource=(value)
      instance_variable_set(:"@#{janus_scope}", value)
    end

    # Returns the `User` class (or `Admin` or whatever) as detected by
    # janus_scope.
    def resource_class
      @resource_class ||= janus_scope.camelize.constantize
    end

    # Alias for janus_scope.
    def resource_name
      janus_scope
    end

    def resource_authentication_params
      if params.respond_to?(:permit)
        params.require(janus_scope).permit(*resource_class.authentication_keys)
      else
        params[janus_scope].slice(*resource_class.authentication_keys)
      end
    end

    # Returns the `UserMailer` class (or `AdminMailer` or whatever) as detected
    # by janus_scope.
    def mailer_class
      @mailer_class ||= (janus_scope.camelize + 'Mailer').constantize
    end
  end
end
