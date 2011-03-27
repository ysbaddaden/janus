module Janus
  module Config
    mattr_accessor :authentication_keys, :stretches, :pepper
    
    self.stretches = 10
  end
end
