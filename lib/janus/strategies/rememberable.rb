module Janus
  module Strategies
    module Rememberable < Base
      def valid?
        resource.include?(Janus::Models::Rememberable) && !remember_cookie.nil?
      end

      def authenticate!
        user = resource.find_for_remember_authentication(remember_cookie)
        
        if user.nil?
          request.cookies.delete(remember_cookie_name)
          pass!
        else
          success!(user)
        end
      end

      private
        def remember_cookie
          request.cookies[remember_cookie_name]
        end

        def remember_cookie_name
          "remember_#{scope}"
        end
    end
  end
end
