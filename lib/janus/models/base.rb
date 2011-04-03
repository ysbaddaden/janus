module Janus
  module Models
    module Base
      extend ActiveSupport::Concern
      
      module ClassMethods
        def generate_token(column_name, size = 32)
          loop do
            token = ActiveSupport::SecureRandom.hex(size)
            return token unless where(column_name => token).any?
          end
        end
      end
    end
  end
end
