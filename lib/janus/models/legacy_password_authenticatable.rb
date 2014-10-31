module Janus
  module Models
    # = LegacyPasswordAuthenticatable
    #
    # This model should be used as a temporary transition solution to quietly
    # upgrade your password digest scheme for something stronger, or when
    # migrating your database to a new codebase for example.
    #
    # When a users logs in using a password that is valid against the old
    # digest, then we can log them in and transparently upgrade the password
    # (ie. unset encrypted_legacy_password and set encrypted_password).
    #
    # This is intended as a temporary solution, to avoid bothering users too
    # much with an explanation email and to avoid the hassle of using the
    # reset password feature. This alternative solution may eventually come
    # up for users that didn't sign in after a given period.
    #
    # == Required columns:
    #
    # - encrypted_legacy_password
    #
    # == Configuration
    #
    # There are no configuration, but you must implement both the
    # valid_legacy_password? and digest_legacy_password methods to behave
    # correcty with your legacy digest scheme.
    #
    module LegacyPasswordAuthenticatable
      extend ActiveSupport::Concern

      included do
        include Janus::Models::DatabaseAuthenticatable unless include?(Janus::Models::DatabaseAuthenticatable)
        begin
          attr_protected :encrypted_legacy_password
        rescue
        end

        attr_reader :legacy_password
      end

      def valid_password?(password)
        super || valid_legacy_password?(password) && update_attributes(password: password)
      end

      def password=(password)
        self.encrypted_legacy_password = nil unless password.blank?
        super
      end

      def legacy_password=(password)
        @legacy_password = password
        self.encrypted_legacy_password = digest_legacy_password(@legacy_password) unless @legacy_password.blank?
      end

      # Validate a password against the encrypted_legacy_password.
      #
      # You must implement this method.
      def valid_legacy_password?(password)
        raise NotImplementedError, "You must implement #{self.class.name}#valid_legacy_password?(password)"
      end

      # Digest the password using the legacy digest method you previously used
      # to authenticate people against.
      def digest_legacy_password(password)
        raise NotImplementedError, "You must implement #{self.class.name}#digest_legacy_password(password)"
      end

      protected

        def password_required?
          if encrypted_legacy_password?
            false
          else
            super
          end
        end
    end
  end
end
