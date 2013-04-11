module Janus
  module Models
    module RemoteToken
      extend ActiveSupport::Concern

      included do
        include Janus::Models::Base

        before_save :reset_token
      end

      # Generates an unique token.
      def reset_token
        self.token = self.class.generate_token(:token)
      end
    end
  end
end
