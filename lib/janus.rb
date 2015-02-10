require 'active_support/core_ext/class'
require 'janus/version'
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
    autoload :DatabaseAuthenticatable, 'janus/models/database_authenticatable'
    autoload :LegacyPasswordAuthenticatable, 'janus/models/legacy_password_authenticatable'
    autoload :Confirmable,             'janus/models/confirmable'
    autoload :Rememberable,            'janus/models/rememberable'
    autoload :RemoteAuthenticatable,   'janus/models/remote_authenticatable'
    autoload :RemoteToken,             'janus/models/remote_token'
    autoload :Trackable,               'janus/models/trackable'
    autoload :TokenAuthenticatable,    'janus/models/token_authenticatable'
  end

  module Strategies
    autoload :Base,                    'janus/strategies/base'
    autoload :Rememberable,            'janus/strategies/rememberable'
    autoload :RemoteAuthenticatable,   'janus/strategies/remote_authenticatable'
    autoload :TokenAuthenticatable,    'janus/strategies/token_authenticatable'
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

