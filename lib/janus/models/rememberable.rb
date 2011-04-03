module Janus
  module Models
    module Rememberable
      extend ActiveSupport::Concern

      # Generates an unique remote_token.
      def remember_me!
        update_attribute(:remember_token, self.class.generate_token(:remember_token))
      end

      # Nullifies remote_token.
      def forget_me!
        update_attribute(:remember_token, nil) unless remember_token.nil?
      end

      module ClassMethods
        def find_for_remember_authentication(token)
          where(:remember_token => token).first
        end
      end
    end
  end
end
