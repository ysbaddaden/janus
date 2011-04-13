module Janus
  module InternalHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :janus_scope, :resource, :resource_class, :resource_name
    end

    def authenticate!
      send("authenticate_#{janus_scope}!")
    end

    def janus_scope
      @janus_scope ||= self.class.name.split('::', 2).first.underscore.singularize
    end

    def resource
      instance_variable_get(:"@#{janus_scope}")
    end

    def resource=(value)
      instance_variable_set(:"@#{janus_scope}", value)
    end

    def resource_class
      @resource_class ||= janus_scope.camelize.constantize
    end

    def resource_name
      janus_scope
    end
  end
end
