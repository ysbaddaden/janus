require 'janus/config'
require 'janus/hooks'
require 'janus/strategies'
require 'janus/manager'
require 'janus/routes'

module Janus
  class NotAuthenticated < StandardError
    cattr_accessor :scope

    def initialize(scope)
      super("")
      self.scope = scope
    end
  end

  autoload :TestHelper,               'janus/test_helper'

  autoload :Helpers,                  'janus/controllers/helpers'
  autoload :SessionsController,       'janus/controllers/sessions_controller'
  autoload :RegistrationsController,  'janus/controllers/registrations_controller'
#  autoload :ConfirmationsController,  'janus/controllers/confirmations_controller'
#  autoload :PasswordsController,      'janus/controllers/password_controller'

  module Models
    autoload :Base,                    'janus/models/base'
    autoload :DatabaseAuthenticatable, 'janus/models/database_authenticatable'
    autoload :RemoteAuthenticatable,   'janus/models/remote_authenticatable'
    autoload :Rememberable,            'janus/models/rememberable'
    autoload :RemoteToken,             'janus/models/remote_token'
  end

  module Strategies
    autoload :Base,                  'janus/strategies/base'
    autoload :RemoteAuthenticatable, 'janus/strategies/remote_authenticatable'
    autoload :Rememberable,          'janus/strategies/rememberable'
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

