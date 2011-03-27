require 'bcrypt'

module Janus
  module Models
    # The password encryption logic comes from Plataformatec's Devise:
    # http://github.com/plataformatec/devise
    module DatabaseAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_reader :password
      end

      def password=(new_password)
        @password = new_password
        self.encrypted_password = digest_password(@password) unless @password.blank?
      end

      def valid_password?(password)
        ::BCrypt::Password.new(self.encrypted_password) == "#{password}#{self.class.pepper}"
      end

      def digest_password(password)
        ::BCrypt::Password.create("#{password}#{self.class.pepper}", :cost => self.class.stretches).to_s
      end

      def clean_up_passwords
        @password = nil
      end

      module ClassMethods
        def find_for_database_authentication(params)
          where(:email => params[:email]).first
        end

        def stretches
          @stretches || Janus.config.stretches
        end

        def stretches=(stretches)
          @stretches = stretches
        end

        def pepper
          @pepper || Janus.config.pepper
        end

        def pepper=(pepper)
          @pepper = pepper
        end
      end
    end
  end
end
