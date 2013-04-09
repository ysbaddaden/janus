# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "janus"
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Julien Portalier"]
  s.date = "2013-04-09"
  s.description = "Janus is an authentication engine for Ruby on Rails."
  s.email = "ysbaddaden@gmail.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "lib/generators/janus/install_generator.rb",
    "lib/generators/janus/resource_generator.rb",
    "lib/generators/templates/confirmations/new.html.erb",
    "lib/generators/templates/confirmations_controller.erb",
    "lib/generators/templates/janus.en.yml",
    "lib/generators/templates/janus.rb",
    "lib/generators/templates/model.erb",
    "lib/generators/templates/passwords/edit.html.erb",
    "lib/generators/templates/passwords/new.html.erb",
    "lib/generators/templates/passwords_controller.erb",
    "lib/generators/templates/registrations/edit.html.erb",
    "lib/generators/templates/registrations/new.html.erb",
    "lib/generators/templates/registrations_controller.erb",
    "lib/generators/templates/sessions/new.html.erb",
    "lib/generators/templates/sessions_controller.erb",
    "lib/janus.rb",
    "lib/janus/config.rb",
    "lib/janus/controllers/confirmations_controller.rb",
    "lib/janus/controllers/helpers.rb",
    "lib/janus/controllers/internal_helpers.rb",
    "lib/janus/controllers/passwords_controller.rb",
    "lib/janus/controllers/registrations_controller.rb",
    "lib/janus/controllers/sessions_controller.rb",
    "lib/janus/controllers/url_helpers.rb",
    "lib/janus/helper.rb",
    "lib/janus/hooks.rb",
    "lib/janus/hooks/rememberable.rb",
    "lib/janus/hooks/remote_authenticatable.rb",
    "lib/janus/hooks/trackable.rb",
    "lib/janus/mailer.rb",
    "lib/janus/manager.rb",
    "lib/janus/models/base.rb",
    "lib/janus/models/confirmable.rb",
    "lib/janus/models/database_authenticatable.rb",
    "lib/janus/models/rememberable.rb",
    "lib/janus/models/remote_authenticatable.rb",
    "lib/janus/models/remote_token.rb",
    "lib/janus/models/trackable.rb",
    "lib/janus/rails.rb",
    "lib/janus/routes.rb",
    "lib/janus/sinatra.rb",
    "lib/janus/strategies.rb",
    "lib/janus/strategies/base.rb",
    "lib/janus/strategies/database_authenticatable.rb",
    "lib/janus/strategies/rememberable.rb",
    "lib/janus/strategies/remote_authenticatable.rb",
    "lib/janus/test_helper.rb"
  ]
  s.homepage = "http://github.com/ysbaddaden/janus"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.0"
  s.summary = "Authentication engine for Ruby on Rails."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, [">= 0"])
    else
      s.add_dependency(%q<addressable>, [">= 0"])
    end
  else
    s.add_dependency(%q<addressable>, [">= 0"])
  end
end

