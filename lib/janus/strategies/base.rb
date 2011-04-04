module Janus
  module Strategies
    # Base class for writing authentication strategies.
    class Base
      attr_reader :scope, :manager, :request, :cookies, :user

      def initialize(scope, manager) # :nodoc:
        @scope, @manager = scope, manager
        @request, @cookies = manager.request, manager.cookies
      end

      def valid?
        true
      end

      def pass
      end

      def success!(user)
        @user = user
      end

      def success?
        !@user.nil?
      end

      def resource
        @resource ||= scope.to_s.camelize.constantize
      end

      def authenticate!
        raise StandardError.new("You must define the #{self.class.name}#authenticate! method.")
      end

      def auth_method
        :login
      end
    end
  end
end
