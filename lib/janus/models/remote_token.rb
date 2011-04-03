module Janus
  module Models
    module RemoteToken
      def self.included(klass)
        klass.class_eval do
          include Janus::Models::Base
          before_save :reset_token
        end
      end

      # Generates an unique token.
      def reset_token
        self.token = self.class.generate_token(:token, 32)
      end
    end
  end
end
