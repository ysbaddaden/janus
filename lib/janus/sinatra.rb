require "janus"
require "sinatra/base"

module Sinatra
  module Janus
    module Helpers
      def janus
        @janus ||= ::Janus::Manager.new(request, request.cookies)
      end

      def authenticate!(scope)
        janus.authenticate!(scope)
      end

      def signed_in?(scope)
        janus.authenticate?(scope)
      end
    end

    def self.registered(app)
      app.helpers Helpers
    end
  end

  def janus(*resources)
    resources.each do |plural|
      singular = plural.to_s.singularize
      klass = singular.camelize.constantize

      class_eval <<-EOV
        def authenticate_#{singular}!
          authenticate!(:#{singular})
        end

        def #{singular}_signed_in?
          signed_in?(:#{singular})
        end

        def current_#{singular}
          @current_#{singular} ||= janus.authenticate(:#{singular})
        end

        def #{singular}_session
          janus.session(:#{singular}) if #{singular}_signed_in?
        end
      EOV
    end
  end

  register Janus
end
