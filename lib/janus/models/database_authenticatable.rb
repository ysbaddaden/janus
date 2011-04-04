require 'bcrypt'

module Janus
  module Models
    # The password encryption logic comes from Plataformatec's Devise:
    # http://github.com/plataformatec/devise
    module DatabaseAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_reader   :password
        attr_accessor :current_password
        
        validates :password, :presence => true, :confirmation => true, :if => :password_required?
        validate :validate_current_password, :on => :update, :if => :current_password
        
        janus_config(:authentication_keys, :stretches, :pepper)
      end

      def password=(password)
        @password = password
        self.encrypted_password = digest_password(@password) unless @password.blank?
      end

      def valid_password?(password)
        ::BCrypt::Password.new(encrypted_password) == "#{password}#{self.class.pepper}"
      end

      def digest_password(password)
        ::BCrypt::Password.create("#{password}#{self.class.pepper}", :cost => self.class.stretches).to_s
      end

      def clean_up_passwords
        self.password = self.password_confirmation = nil
      end

      protected
        def password_required?
          !persisted? || !!password || !!password_confirmation
        end

        def validate_current_password
          errors.add(:current_password, :invalid) unless valid_password?(current_password)
        end

      module ClassMethods
        def find_for_database_authentication(params)
          params = params.reject { |k,v| !authentication_keys.include?(k.to_sym) }
          where(params).first
        end
      end
    end
  end
end
