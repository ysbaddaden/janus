require 'active_support/time'

module Janus
  module Config
    mattr_accessor :contact_email
    
    # DatabaseAuthenticatable
    mattr_accessor :authentication_keys, :stretches, :pepper
    self.authentication_keys = [:email]
    self.stretches = 10

    # Rememberable
    mattr_accessor :remember_for, :extend_remember_period, :remember_across_browsers
    self.remember_for = 2.weeks
    self.extend_remember_period = false
#    self.remember_across_browsers = false

    # RemoteAuthenticatable
#    mattr_accessor :remote_authentication_key
#    self.remote_authentication_key = :auth_token
  end
end
