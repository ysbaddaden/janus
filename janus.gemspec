# -*- encoding: utf-8 -*-
require File.expand_path('../lib/janus/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Julien Portalier"]
  gem.email         = ["julien@portalier.com"]
  gem.description   = gem.summary = "Authentication engine for Ruby on Rails"
  gem.homepage      = "http://github.com/ysbaddaden/janus"
  gem.license       = "MIT"

  gem.files         = `git ls-files | grep -Ev '^(Gemfile|gemfiles|test)'`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "janus"
  gem.require_paths = ["lib"]
  gem.version       = Janus::VERSION::STRING

  gem.cert_chain    = ['certs/ysbaddaden.pem']
  gem.signing_key   = File.expand_path('~/.ssh/gem-private_key.pem') if $0 =~ /gem\z/

  gem.add_dependency 'addressable'

  gem.add_development_dependency 'rails', '>= 3.0.0'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'bcrypt-ruby'
  gem.add_development_dependency 'scrypt'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'capybara'
end
