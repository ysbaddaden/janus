# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{janus}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Julien Portalier"]
  s.date = %q{2011-03-28}
  s.description = %q{Authentication engine for Ruby on Rails 3.}
  s.email = %q{ysbaddaden@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "lib/janus.rb",
    "lib/janus/config.rb",
    "lib/janus/controllers/helpers.rb",
    "lib/janus/controllers/registrations_controller.rb",
    "lib/janus/controllers/sessions_controller.rb",
    "lib/janus/hooks.rb",
    "lib/janus/manager.rb",
    "lib/janus/models/database_authenticatable.rb",
    "lib/janus/routes.rb",
    "lib/janus/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/ysbaddaden/janus}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Authentication engine for Ruby on Rails 3.}
  s.test_files = [
    "test/functional/home_controller_test.rb",
    "test/functional/janus/manager_test.rb",
    "test/functional/users/registrations_controller_test.rb",
    "test/functional/users/sessions_controller_test.rb",
    "test/functional/users_controller_test.rb",
    "test/integration/users/sessions_test.rb",
    "test/rails_app/app/controllers/application_controller.rb",
    "test/rails_app/app/controllers/home_controller.rb",
    "test/rails_app/app/controllers/users/registrations_controller.rb",
    "test/rails_app/app/controllers/users/sessions_controller.rb",
    "test/rails_app/app/controllers/users_controller.rb",
    "test/rails_app/app/helpers/application_helper.rb",
    "test/rails_app/app/models/user.rb",
    "test/rails_app/config/application.rb",
    "test/rails_app/config/boot.rb",
    "test/rails_app/config/environment.rb",
    "test/rails_app/config/environments/development.rb",
    "test/rails_app/config/environments/production.rb",
    "test/rails_app/config/environments/test.rb",
    "test/rails_app/config/initializers/janus.rb",
    "test/rails_app/config/initializers/secret_token.rb",
    "test/rails_app/config/initializers/session_store.rb",
    "test/rails_app/config/routes.rb",
    "test/rails_app/db/migrate/20110323153820_create_users.rb",
    "test/rails_app/db/schema.rb",
    "test/rails_app/db/seeds.rb",
    "test/test_helper.rb",
    "test/unit/janus_test.rb",
    "test/unit/user_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0.5"])
      s.add_runtime_dependency(%q<bcrypt-ruby>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0.5"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0.5"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
  end
end

