begin
  require 'bcrypt'
rescue LoadError
end

begin
  require 'scrypt'
rescue LoadError
end

module Janus
  module Models
    # = DatabaseAuthenticatable
    #
    # This is the initial part and is required for email + password registration
    # and logins. Passwords are automatically encrypted following Devise's
    # default encryption logic, which relies on bcrypt.
    #
    # == Required columns:
    #
    # - email
    # - encrypted_password
    #
    # == Configuration
    #
    # - +stretches+
    # - +pepper+
    # - +authentication_keys+ - required keys for authenticating a user, defaults to <tt>[:email]</tt>
    #
    module DatabaseAuthenticatable
      extend ActiveSupport::Concern

      included do
        include Janus::Models::Base unless include?(Janus::Models::Base)

        begin
          attr_protected :encrypted_password, :reset_password_token, :reset_password_sent_at
        rescue
        end
        attr_reader    :password
        attr_accessor  :current_password

        validates :password, :presence => true, :confirmation => true, :if => :password_required?
        validate :validate_current_password, :on => :update, :if => :current_password

        janus_config(:authentication_keys, :encryptor, :stretches, :pepper, :scrypt_options)
      end

      def password=(password)
        @password = password
        self.encrypted_password = digest_password(@password) unless @password.blank?
      end

      # Checks if a given password matches this user's password.
      def valid_password?(password)
        case self.class.encryptor
        when :bcrypt
          ::BCrypt::Password.new(encrypted_password) == salted_password(password)
        when :scrypt
          ::SCrypt::Password.new(encrypted_password || "") == salted_password(password)
        end
      rescue BCrypt::Errors::InvalidHash, SCrypt::Errors::InvalidHash
        false
      end

      # Digests a password using either bcrypt or scrypt (as configured by `config.encryptor`).
      def digest_password(password)
        case self.class.encryptor
        when :bcrypt
          ::BCrypt::Password.create(salted_password(password), :cost => self.class.stretches).to_s
        when :scrypt
          ::SCrypt::Password.create(salted_password(password), self.class.scrypt_options).to_s
        end
      end

      def salted_password(password)
        "#{password}#{self.class.pepper}"
      end

      def clean_up_passwords
        self.current_password = self.password = self.password_confirmation = nil
      end

      def generate_reset_password_token!
        self.reset_password_token = self.class.generate_token(:reset_password_token)
        self.reset_password_sent_at = Time.now
        save
      end

      def reset_password!(params)
        %w{password password_confirmation}.each do |attr|
          send("#{attr}=", params[attr]) if params.has_key?(attr)
        end

        self.reset_password_sent_at = self.reset_password_token = nil
        save
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

        def find_for_password_reset(token)
          user = find_by_reset_password_token(token) unless token.blank?

          if user && user.reset_password_sent_at < 2.days.ago
            user.reset_password_token = user.reset_password_sent_at = nil
            user.save
            user = nil
          end

          user
        end
      end
    end
  end
end
