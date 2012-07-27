ENV["RAILS_ENV"] = "test"

require File.expand_path('../rails_app/config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  self.fixture_path = File.expand_path('../fixtures', __FILE__)
  fixtures :all

  # Executes the given block having first modified Janus' encryptor.
  # Resets the encryptor to its previous state after the block execution.
  def with_encryptor(encryptor)
    default_encryptor = Janus::Config.encryptor
    begin
      Janus::Config.encryptor = encryptor
      yield
    ensure
      Janus::Config.encryptor = default_encryptor
    end
  end
end

class ActionController::TestCase
  include Janus::TestHelper

  def assert_email(count = 1, message = nil)
    assert_difference('ActionMailer::Base.deliveries.size', count, message) do
      yield
    end
  end

  def assert_no_email(message = nil)
    assert_no_difference('ActionMailer::Base.deliveries.size', message) do
      yield
    end
  end
end

class ActionDispatch::IntegrationTest
  self.fixture_path = File.expand_path('../fixtures', __FILE__)

  include Capybara::DSL

  teardown { page.reset! }

  def sign_up(user, options = {})
    scope = options[:scope]
    route = "new_#{scope}_registration_url"
    
    visit send(route, options[:url])
    fill_in "#{scope}_email", :with => user[:email]
    fill_in "#{scope}_password", :with => user[:password]
    fill_in "#{scope}_password_confirmation", :with => user[:password]
    find('input[name=commit]').click
  end

  def sign_in(user, options = {})
    scope = options[:scope] || Janus.scope_for(user)
    route = "new_#{scope}_session_url"
    
    visit send(route, options[:url])
    fill_in "#{scope}_email",    :with => user.email
    fill_in "#{scope}_password", :with => 'secret'
    check "remember_me" if options[:remember_me]
    find('input[name=commit]').click
  end

  def sign_out(user_or_scope)
    scope = Janus.scope_for(user_or_scope)
    route = "destroy_#{scope}_session_url"
    visit send(route)
  end

  def service_login(scope, options)
    route = "new_#{scope}_session_url"
    visit send(route, options)
  end

  def close_user_session
    driver = Capybara.current_session.driver
#    case driver
#    when Capybara::Driver::Selenium
#      browser = driver.browser
#      browser.manage.delete_cookie(cookie_name)
#    when Capybara::Driver::RackTest
      cookie_jar = driver.browser.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
      cookie_jar.instance_variable_get(:@cookies).reject! do |cookie|
        expires = cookie.instance_variable_get(:@options)["expires"]
        expires.nil? || Time.parse(expires) < Time.now
      end
#    end
  end

  def assert_authenticated
    assert has_selector?("a#my_page"), "Expected user to be authenticated."
  end

  def assert_not_authenticated
    assert has_selector?("a#sign_in"), "Expected user to not be authenticated."
  end

  def assert_select(selector)
    assert has_selector?(selector), "Expected selector <#{selector}> but found none."
  end
end

class ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end

