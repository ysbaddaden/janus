module Janus
  module Models
    module Base
      extend ActiveSupport::Concern

      module ClassMethods
        def generate_token(column_name, size = 32)
          loop do
            token = SecureRandom.hex(size)
            return token unless where(column_name => token).any?
          end
        end

        def janus_config(*keys)
          keys.each do |key|
            class_eval <<-EOV
            def self.#{key}
              @#{key} || Janus::Config.#{key}
            end

            def self.#{key}=(value)
              @#{key} = value
            end
            EOV
          end
        end

      end
    end
  end
end
