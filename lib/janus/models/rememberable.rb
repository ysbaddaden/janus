module Janus
  module Models
    # = Rememberable
    #
    # Allows a user to check a remember me check box when she logs in through
    # DatabaseAuthenticatable. It will set a cookie with a configurable
    # expiration date.
    #
    # == Required columns
    #
    # - remember_token
    # - remember_created_at
    #
    # == Configuration
    #
    # - remember_for - how long to remember the user, for instance <tt>1.week</tt>.
    # - :extend_remember_period - set to true to extend the remember cookie every time the user logs in.
    #
    module Rememberable
      extend ActiveSupport::Concern

      included do
        include Janus::Models::Base unless include?(Janus::Models::Base)

        begin
          attr_protected :remember_token, :remember_created_at
        rescue
        end
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
          user = where(:remember_token => token).first unless token.blank?

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
