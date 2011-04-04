require 'active_support/time'

module Janus
  module Config
    # DatabaseAuthenticatable
    mattr_accessor :authentication_keys, :stretches, :pepper
    self.authentication_keys = [:email]
    self.stretches = 10

    # Rememberable
    mattr_accessor :remember_for, :remember_across_browsers, :extend_remember_period
    self.remember_for = 2.weeks
#    self.remember_across_browsers = false
#    self.extend_remember_period = false

    # RemoteAuthenticatable
#    mattr_accessor :remote_authentication_key
#    self.remote_authentication_key = :auth_token
  end
end
