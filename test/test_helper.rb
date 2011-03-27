ENV["RAILS_ENV"] = "test"

require File.expand_path('../rails_app/config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  self.fixture_path = File.expand_path('../fixtures', __FILE__)
  fixtures :all
end

class ActionController::TestCase
  include Janus::TestHelper
end

class ActionDispatch::IntegrationTest
  self.fixture_path = File.expand_path('../fixtures', __FILE__)

  def sign_in(user, options = {})
    scope = Janus.scope_for(user_or_scope)
    route = "new_#{scope}_session_path"
    
    visit send(route)
    fill_in "#{scope}_email",    :with => user.email
    fill_in "#{scope}_password", :with => 'secret'
    click_button "#{scope}_submit"
  end

  def sign_out(user_or_scope)
    scope = Janus.scope_for(user_or_scope)
    route = "new_#{scope}_session_path"
    visit destroy_user_session_path
  end
end

