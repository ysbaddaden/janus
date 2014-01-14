module Janus
  module Models
    # = TokenAuthenticatable
    #
    # Allows to connect through an unique identifier.
    #
    # The strategy to generate the authentication token is up to you. You may
    # either generate a token when a user is created:
    #
    #   before_create :reset_authentication_token
    #
    # or you may change the token whenever a user is saved:
    #
    #   before_save :reset_authentification_token
    #
    # or whenever its password is changed:
    #
    #   before_save :reset_authentication_token, :if => :encrypted_password_changed?
    module TokenAuthenticatable
      extend ActiveSupport::Concern

      included do
        include Janus::Models::Base unless include?(Janus::Models::Base)

        begin
          attr_protected :authentication_token, :token_authentication_valid_for, :reusable_authentication_token
        rescue
        end

        janus_config :token_authentication_key, :token_authentication_valid_for, :reusable_authentication_token
      end

      # Generates an unique authentication token and saves the model.
      # Any existing token will be overwritten.
      def reset_authentication_token!
        reset_authentication_token
        save
      end

      # Generates an unique authentification token.
      def reset_authentication_token
        self.authentication_token = self.class.generate_token(:authentication_token)
        self.authentication_token_created_at = Time.now
      end

      # Destroys the auth token.
      def destroy_authentication_token!
        update_attribute(:authentication_token, nil)
      end

      module ClassMethods
        def find_for_token_authentication(token)
          if record = where(:authentication_token => token).first
            if expired_authentication_token?(record)
              record.destroy_authentication_token!
              return
            end
            record.destroy_authentication_token! unless reusable_authentication_token
            record
          end
        end

        def expired_authentication_token?(record)
          token_authentication_valid_for && record.authentication_token_created_at &&
            record.authentication_token_created_at < Time.now - token_authentication_valid_for
        end
      end
    end
  end
end
