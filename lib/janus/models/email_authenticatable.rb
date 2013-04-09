module Janus
  module Models
    module EmailAuthenticatable
      extend ActiveSupport::Concern

      included do
        begin
          attr_protected :email_token, :email_created_at
        rescue
        end
        janus_config :email_authentication_token, :email_token_valid_for
      end

      # Generates an unique email_token.
      def generate_email_token!
        self.email_token = self.class.generate_token(:email_token)
        self.email_token_created_at = Time.now
        save
      end

      # Nullifies email_token.
      def clear_email_token!
        self.email_token = self.email_token_created_at = nil
        save
      end

      module ClassMethods
        def self.find_for_email_authentication(token)
          user = where(:email_token => token).first unless token.blank?
          if user and user.email_token_created_at < email_token_valid_for.ago
            user.clear_email_token!
            user = nil
          end
          user
        end
      end

    end
  end
end
