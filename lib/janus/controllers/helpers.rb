module Janus
  module Helpers
    extend ActiveSupport::Concern

    included do
      rescue_from Janus::NotAuthenticated do |exception|
        respond_to do |format|
          format.html { redirect_to send(:"new_#{exception.scope}_session_url") }
          format.any  { head :unauthorized }
        end
      end
    end

    def janus
      @janus ||= Janus::Manager.new(request)
    end

    def handle_unverified_requests
      janus.logout
    end

    module ClassMethods
      def janus(*scopes)
        scopes.each do |scope|
          class_eval <<-EOV
            helper_method :#{scope}_signed_in?, :current_#{scope}, :#{scope}_session
            
            def authenticate_#{scope}!
              janus.authenticate!(:#{scope})
            end
            
            def current_#{scope}
              @current_#{scope} ||= janus.authenticate(:#{scope})
            end
            
            def #{scope}_signed_in?
              janus.authenticate?(:#{scope})
            end
            
            def #{scope}_session
              janus.session(:#{scope}) if #{scope}_signed_in?
            end
          EOV
        end
      end
    end
  end
end
