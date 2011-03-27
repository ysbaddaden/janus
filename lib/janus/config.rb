module Janus
  module Config
    mattr_accessor :stretches, :pepper
    
    self.stretches = 10
  end
end
