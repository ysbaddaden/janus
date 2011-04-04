module Janus
  module Models
    module Rememberable
      extend ActiveSupport::Concern

      included do
        janus_config :remember_for
      end

      # Generates an unique remote_token.
      def remember_me!
        self.remember_token = self.class.generate_token(:remember_token)
        self.remember_created_at = Time.now
        self.save
      end

      # Nullifies remote_token.
      def forget_me!
        return if remember_token.nil?
        
        self.remember_token = nil
        self.remember_created_at = nil
        self.save
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
