require 'janus/hooks/rememberable'

module Janus
  module Strategies
    class Rememberable < Base
      def valid?
        rememberable? && !remember_cookie.nil?
      end

      def authenticate!
        user = resource.find_for_remember_authentication(remember_cookie)
        
        if user.nil?
          destroy_remember_cookie
          pass
        else
          success!(user)
        end
      end

      def self.remember_cookie_name(scope)
        "remember_#{scope}_token"
      end

      private
        def destroy_remember_cookie
          request.cookies.delete(remember_cookie_name)
        end

        def remember_cookie_name
          self.class.remember_cookie_name(scope)
        end

        def remember_cookie
          request.cookies[remember_cookie_name]
        end

        def rememberable?
          resource.include?(Janus::Models::Rememberable)
        end
    end
  end
end
