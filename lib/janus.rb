require 'janus/config'
require 'janus/hooks'
require 'janus/manager'

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
#  autoload :RegistrationsController,  'janus/controllers/registrations_controller'
#  autoload :ConfirmationsController,  'janus/controllers/confirmations_controller'
#  autoload :PasswordsController,      'janus/controllers/password_controller'

  module Models
    autoload :DatabaseAuthenticatable, 'janus/models/database_authenticatable'
#    autoload :TokenAuthenticatable,    'janus/models/token_authenticatable'
#    autoload :Rememberable,            'janus/models/rememberable'
#    autoload :SingleSignable,          'janus/models/single_signable'
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
