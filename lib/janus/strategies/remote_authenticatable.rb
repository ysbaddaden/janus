# IMPROVE: redirect to clean the URL from the auth_token.
module Janus
  module Strategies
    class RemoteAuthenticatable < Base
      def valid?
        !auth_token.nil?
      end

      def authenticate!
        user = resource.find_for_remote_authentication(auth_token)
        
        if user
          success!(user)
        else
          pass
        end
      end

      def auth_token
        request.params[:auth_token]
      end

      def auth_method
        :set_user
      end
    end
  end
end
