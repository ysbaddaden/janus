require 'active_support/core_ext/class'
require 'janus/config'
require 'janus/hooks'
require 'janus/strategies'
require 'janus/manager'
require 'janus/rails' if defined?(Rails)

autoload :JanusHelper, 'janus/helper'

module Janus
  class NotAuthenticated < StandardError
    cattr_accessor :scope

    def initialize(scope)
      super("")
      self.scope = scope
    end
  end

  module Models
    autoload :Base,                    'janus/models/base'
    autoload :Confirmable,             'janus/models/confirmable'
    autoload :DatabaseAuthenticatable, 'janus/models/database_authenticatable'
    autoload :EmailAuthenticatable,    'janus/models/email_authenticatable'
    autoload :Rememberable,            'janus/models/rememberable'
    autoload :RemoteAuthenticatable,   'janus/models/remote_authenticatable'
    autoload :RemoteToken,             'janus/models/remote_token'
    autoload :Trackable,               'janus/models/trackable'
  end

  module Strategies
    autoload :Base,                    'janus/strategies/base'
    autoload :Rememberable,            'janus/strategies/rememberable'
    autoload :RemoteAuthenticatable,   'janus/strategies/remote_authenticatable'
  end

  def self.scope_for(user_or_scope)
    case user_or_scope
    when Symbol then user_or_scope
    when String then user_or_scope.to_sym
    else user_or_scope.class.name.underscore.to_sym
    end
  end

  def self.config
    yield(Janus::Config) if block_given?
    Janus::Config
  end
end
