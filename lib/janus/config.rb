require 'active_support/time'

module Janus
  module Config
    mattr_accessor :contact_email

    # DatabaseAuthenticatable
    mattr_accessor :authentication_keys, :encryptor, :stretches, :pepper, :scrypt_options
    self.authentication_keys = [ :email ]

    self.encryptor = :bcrypt
#    self.encryptor = :scrypt

    # bcrypt config
    self.stretches = 10
    self.pepper = nil

    # scrypt config
    self.scrypt_options = { :max_time => 0.25 }

    # Confirmable
    mattr_accessor :confirmation_key #,reconfirmable
    self.confirmation_key = :confirm_token
#    self.reconfirmable = true

    # Rememberable
    mattr_accessor :remember_for, :extend_remember_period #, :remember_across_browsers
    self.remember_for = 1.year
    self.extend_remember_period = false
#    self.remember_across_browsers = false

    # RemoteAuthenticatable
    mattr_accessor :remote_authentication_key
    self.remote_authentication_key = :remote_token

    # TokenAuthenticatable
    mattr_accessor :token_authentication_key
    self.token_authentication_key = :auth_token
  end
end
