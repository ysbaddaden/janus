require 'janus/hooks/remote_authenticatable'

module Janus
  module Models
    module RemoteAuthenticatable
      extend ActiveSupport::Concern

      included do |klass|
        klass.class_eval { has_many :remote_tokens }
      end

      # Generates an unique session token. This token will be used to validate
      # the current session, and must be generated whenever a user signs in on
      # the main site.
      # 
      # The token won't be regenerated if it already exists.
      def generate_session_token!
        update_attribute(:session_token, self.class.generate_token(:session_token)) unless session_token
        session_token
      end

      # Destroys the session token. This must be called whenever the user signs
      # out. Doing so will invalidate all sessions using this token at once
      # --hence single sign out.
      def destroy_session_token!
        update_attribute(:session_token, nil)
      end

      # Returns a temporary token to be used with find_for_remote_authentication.
      def generate_remote_token!
        remote_tokens.create.token
      end

      module ClassMethods
        def find_for_remote_authentication(token)
          remote_token = ::RemoteToken.where(:token => token).first
          
          if remote_token
            remote_token.destroy
            remote_token.user unless remote_token.created_at < 30.seconds.ago
          end
        end

        def remote_authentication_key
          @remote_authentication_key || Janus.config.remote_authentication_key
        end

        def remote_authentication_key=(key)
          @remote_authentication_key = key
        end
      end
    end
  end
end
