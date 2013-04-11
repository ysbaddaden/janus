require 'janus/hooks/trackable'

module Janus
  module Models
    # = Trackable
    #
    # Simple hook to update some columns of your model whenever a user logs in.
    #
    # == Required columns
    #
    # - +sign_in_count+
    # - +current_sign_in_ip+
    # - +current_sign_in_at+
    # - +last_sign_in_ip+
    # - +last_sign_in_at+
    #
    module Trackable
      extend ActiveSupport::Concern

      included do
        include Janus::Models::Base unless include?(Janus::Models::Base)

        begin
          attr_protected :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip
        rescue
        end
      end

      def track!(ip)
        self.sign_in_count += 1

        self.last_sign_in_at = self.current_sign_in_at
        self.last_sign_in_ip = self.current_sign_in_ip

        self.current_sign_in_at = Time.now
        self.current_sign_in_ip = ip

        save(:validate => false)
      end
    end
  end
end
