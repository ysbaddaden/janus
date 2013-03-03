require 'securerandom'

module Janus
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc "Configures Janus into your app"

      def copy_initializer
        template 'janus.rb', 'config/initializers/janus.rb'
      end

      def copy_locale
        template 'janus.en.yml', 'config/locales/janus.en.yml'
      end
    end
  end
end
