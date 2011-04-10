module Janus
  module Models
    module Rememberable
      extend ActiveSupport::Concern

      included do
        attr_protected :remember_token, :remember_created_at
        janus_config :remember_for, :extend_remember_period
      end

      # Generates an unique remote_token.
      def remember_me!
        self.remember_token = self.class.generate_token(:remember_token)
        self.remember_created_at = Time.now
        save
      end

      # Nullifies remote_token.
      def forget_me!
        self.remember_token = self.remember_created_at = nil
        save
      end

      module ClassMethods
        def find_for_remember_authentication(token)
          user = where(:remember_token => token).first
          
          if user && user.remember_created_at < remember_for.ago
            user.forget_me!
            user = nil
          end
          
          user
        end
      end
    end
  end
end
