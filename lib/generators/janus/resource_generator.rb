module Janus
  module Generators
    class ResourceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../templates', __FILE__)

      argument :strategies, :type => :array, :banner => "strategy strategy",
        :default => %w{session registration confirmation password remember}

      desc "Generates an authenticatable resource (with migration," <<
           "routes, strategies and views)"

      def create_resource
        attributes  = [singular_name]
        attributes += %w{email:string encrypted_password:string}
        attributes += %w{remember_token:string:uniq remember_created_at:datetime} if strategies.include?('remember')
        attributes += %w{confirmation_token:string:uniq confirmation_sent_at:datetime confirmed_at:datetime} if strategies.include?('confirmation')
        attributes += %w{reset_password_token:string:uniq reset_password_sent_at:datetime} if strategies.include?('password')
        attributes += %w{session_token:string:uniq} if strategies.include?('remote')
        attributes += %w{sign_in_count:integer last_sign_in_at:datetime last_sign_in_ip:string current_sign_in_at:datetime current_sign_in_ip:string} if strategies.include?('track')
        generate('model', attributes.join(' '))

        modules = [
          "  include Janus::Models::Base",
          "  include Janus::Models::DatabaseAuthenticatable",
        ]
        modules << "  include Janus::Models::Rememberable" if strategies.include?('remember')
        modules << "  include Janus::Models::Confirmable" if strategies.include?('confirmation')
        modules << "  include Janus::Models::Trackable" if strategies.include?('track')
        modules << "  include Janus::Models::RemoteAuthenticatable" if strategies.include?('remote')
        inject_into_class "app/models/#{singular_name}.rb", class_name, modules.join("\n") + "\n"
      end

      def create_controllers_and_views
        if strategies.include?('session')
          template 'sessions_controller.erb', "app/controllers/#{plural_name}/sessions_controller.rb"
          template 'sessions/new.html.erb',   "app/views/#{plural_name}/sessions/new.html.erb"
        end
        if strategies.include?('registration')
          template 'registrations_controller.erb', "app/controllers/#{plural_name}/registrations_controller.rb"
          template 'registrations/new.html.erb',   "app/views/#{plural_name}/registrations/new.html.erb"
          template 'registrations/edit.html.erb',  "app/views/#{plural_name}/registrations/edit.html.erb"
        end
        if strategies.include?('confirmation')
          template 'confirmations_controller.erb', "app/controllers/#{plural_name}/confirmations_controller.rb"
          template 'confirmations/new.html.erb',   "app/views/#{plural_name}/confirmations/new.html.erb"
        end
        if strategies.include?('password')
          template 'passwords_controller.erb', "app/controllers/#{plural_name}/passwords_controller.rb"
          template 'passwords/new.html.erb',   "app/views/#{plural_name}/passwords/new.html.erb"
          template 'passwords/edit.html.erb',  "app/views/#{plural_name}/passwords/edit.html.erb"
        end
      end

      def add_janus_route
        route "janus :#{plural_name}, " + controllers.map { |ctrl| ":#{ctrl} => true" }.join(', ')
      end

      private
        def controllers
          strategies & %w{session registration confirmation password}
        end
    end
  end
end
