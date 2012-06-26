module Janus
  module Helpers
    extend ActiveSupport::Concern

    included do
      helper_method :signed_in?

      rescue_from Janus::NotAuthenticated do |exception|
        respond_to do |format|
          format.html { redirect_to send("new_#{exception.scope}_session_url") }
          format.any  { head :unauthorized }
        end
      end
    end

    # Returns the current instance of Janus::Manager.
    def janus
      @janus ||= Janus::Manager.new(request, cookies)
    end

    # Signs the current user out (from all scopes at once) in case of a CSRF attack.
    # See ActionController::RequestForgeryProtection for documentation.
    def handle_unverified_requests
      janus.logout
      super
    end

    # Returns true if a scope user is currently authenticated.
    def signed_in?(scope)
      janus.authenticate?(scope)
    end

    module ClassMethods
      # Aliases some Janus methods for convenience. For instance calling
      # `janus(:user, :admin)` will generate the following methods:
      #
      #   authenticate_user!   # => janus.authenticate!(:user)
      #   current_user         # => janus.authenticate(:user)
      #   user_signed_in?      # => janus.authenticate?(:user)
      #   user_session         # => janus.sesssion(:user)
      #
      #   authenticate_admin!  # => janus.authenticate!(:admin)
      #   current_admin        # => janus.authenticate(:admin)
      #   admin_signed_in?     # => janus.authenticate?(:admin)
      #   admin_session        # => janus.sesssion(:admin)
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
