module Janus
  module Models
    module Confirmable
      extend ActiveSupport::Concern

      included do
        attr_protected :confirmation_token, :confirmation_sent_at, :confirmed_at
        janus_config(:confirmation_key)
        
        before_create :generate_confirmation_token
#        before_update :generate_confirmation_token, :if => :email_changed?
      end

      # Generates the confirmation token, but won't save the record.
      def generate_confirmation_token
        self.confirmation_token = self.class.generate_token(:confirmation_token)
        self.confirmation_sent_at = Time.now
      end

      # Confirms the record.
      def confirm!
        self.confirmation_token = self.confirmation_sent_at = nil
        self.confirmed_at = Time.now
        save
      end

      def confirmed?
        confirmed_at?
      end

      module ClassMethods
        def find_for_confirmation(token)
          where(:confirmation_token => token).first unless token.blank?
        end
      end
    end
  end
end
