module Janus
  module Strategies
    class TokenAuthenticatable < Base
      def valid?
        resource.include?(Janus::Models::TokenAuthenticatable) and !auth_token.nil?
      end

      def authenticate!
        user = resource.find_for_token_authentication(auth_token)
        if user
          success!(user)
        else
          pass
        end
      end

      def auth_token
        request.params[resource.token_authentication_key]
      end
    end
  end
end
