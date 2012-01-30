require 'janus'
require 'janus/routes'

module Janus
  autoload :Mailer,                    'janus/mailer'
  autoload :TestHelper,                'janus/test_helper'

  autoload :Helpers,                   'janus/controllers/helpers'
  autoload :UrlHelpers,                'janus/controllers/url_helpers'
  autoload :InternalHelpers,           'janus/controllers/internal_helpers'

  autoload :SessionsController,        'janus/controllers/sessions_controller'
  autoload :RegistrationsController,   'janus/controllers/registrations_controller'
  autoload :ConfirmationsController,   'janus/controllers/confirmations_controller'
  autoload :PasswordsController,       'janus/controllers/passwords_controller'
end

