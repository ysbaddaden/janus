# IMPROVE: redirect to clean the URL from the auth_token.
module Janus
  module Strategies
    class RemoteAuthenticatable < Base
      def valid?
        resource.include?(Janus::Models::RemoteAuthenticatable) && !remote_token.nil?
      end

      def authenticate!
        user = resource.find_for_remote_authentication(remote_token)
        
        if user
          success!(user)
        else
          pass
        end
      end

      def remote_token
        request.params[resource.remote_authentication_key]
      end

      def auth_method
        :set_user
      end
    end
  end
end
