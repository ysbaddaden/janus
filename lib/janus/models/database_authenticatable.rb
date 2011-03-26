module Janus
  module Models
    module DatabaseAuthenticatable
      extend ActiveSupport::Concern

      def valid_password?(password)
        self.password == crypt_password(password)
      end

      # TODO: implement crypt_password()
      def crypt_password(password)
        password
      end

      module ClassMethods
        def find_for_database_authentication(params)
          where(:email => params[:email]).first
        end
      end
    end
  end
end

