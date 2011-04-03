module Janus
  module Config
    mattr_accessor :authentication_keys, :stretches, :pepper
    
    self.authentication_keys = [:email]
    self.stretches = 10
  end
end
