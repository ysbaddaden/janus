require File.expand_path('../../test_helper', __FILE__)
require 'rails/generators'
require File.expand_path('../../../lib/generators/janus/resource_generator', __FILE__)


class Janus::Generators::ResourceGeneratorTest < Rails::Generators::TestCase
  tests Janus::Generators::ResourceGenerator
  destination Rails.root.join('tmp/test_app').to_s

  setup do
    prepare_destination
    `rails new #{Rails.root.join('tmp/test_app')} -B -S -J -T -G`
  end

  test "standard create" do
    sh "bin/rails g janus:resource user"
    assert_file 'config/routes.rb', /janus :users, :session => true, :registration => true, :confirmation => true/

    assert_file 'app/models/user.rb', /class User < ActiveRecord::Base/
    assert_file 'app/models/user.rb', /include Janus::Models::Base/
    assert_file 'app/models/user.rb', /include Janus::Models::DatabaseAuthenticatable/
    assert_file 'app/models/user.rb', /include Janus::Models::Rememberable/
    assert_file 'app/models/user.rb', /include Janus::Models::Confirmable/
    assert_migration 'db/migrate/create_users.rb', /t\.string :email/

    assert_file 'app/controllers/users/sessions_controller.rb',      /class Users::SessionsController < Janus::SessionsController/
    assert_file 'app/views/users/sessions/new.html.erb'

    assert_file 'app/controllers/users/registrations_controller.rb', /class Users::RegistrationsController < Janus::RegistrationsController/
    assert_file 'app/views/users/registrations/new.html.erb'
    assert_file 'app/views/users/registrations/edit.html.erb'

    assert_file 'app/controllers/users/confirmations_controller.rb', /class Users::ConfirmationsController < Janus::ConfirmationsController/
    assert_file 'app/views/users/confirmations/new.html.erb'

    assert_file 'app/controllers/users/passwords_controller.rb',     /class Users::PasswordsController < Janus::PasswordsController/
    assert_file 'app/views/users/passwords/new.html.erb'
    assert_file 'app/views/users/passwords/edit.html.erb'

    assert_file 'app/mailers/user_mailer.rb', /class UserMailer < Janus::Mailer/
    assert_file 'app/views/user_mailer/confirmation_instructions.html.erb'
    assert_file 'app/views/user_mailer/confirmation_instructions.text.erb'
    assert_file 'app/views/user_mailer/reset_password_instructions.html.erb'
    assert_file 'app/views/user_mailer/reset_password_instructions.text.erb'
  end

  test "custom create" do
    sh "bin/rails g janus:resource admin_user session"
    assert_file 'config/routes.rb', /janus :admin_users, :session => true/

    assert_file 'app/models/admin_user.rb', /class AdminUser < ActiveRecord::Base/
    assert_file 'app/models/admin_user.rb', /include Janus::Models::Base/
    assert_file 'app/models/admin_user.rb', /include Janus::Models::DatabaseAuthenticatable/
    assert_file 'app/models/admin_user.rb', /(?!include Janus::Models::Rememberable)/
    assert_file 'app/models/admin_user.rb', /(?!include Janus::Models::Confirmable)/
    assert_migration 'db/migrate/create_admin_users.rb', /t\.string :email/

    assert_file 'app/controllers/admin_users/sessions_controller.rb', /class AdminUsers::SessionsController < Janus::SessionsController/
    assert_file 'app/views/admin_users/sessions/new.html.erb'

    assert_no_file 'app/controllers/admin_users/registrations_controller.rb'
    assert_no_file 'app/views/admin_users/registrations/new.html.erb'
    assert_no_file 'app/views/admin_users/registrations/edit.html.erb'

    assert_no_file 'app/controllers/admin_users/confirmations_controller.rb'
    assert_no_file 'app/views/admin_users/confirmations/new.html.erb'

    assert_no_file 'app/controllers/admin_users/passwords_controller.rb'
    assert_no_file 'app/views/admin_users/passwords/new.html.erb'
    assert_no_file 'app/views/admin_users/passwords/edit.html.erb'

    assert_no_file 'app/mailers/user_mailer.rb'
    assert_no_file 'app/views/user_mailer/confirmation_instructions.html.erb'
    assert_no_file 'app/views/user_mailer/confirmation_instructions.text.erb'
    assert_no_file 'app/views/user_mailer/reset_password_instructions.html.erb'
    assert_no_file 'app/views/user_mailer/reset_password_instructions.text.erb'
  end

  def sh(cmd)
    system("cd #{Rails.root.join('tmp/test_app')}; #{cmd} > /dev/null")
  end
end
