require 'test_helper'

class Users::SessionsTest < ActionDispatch::IntegrationTest
  include Capybara

  fixtures :all

  test "sign in" do
    visit new_user_session_path
    fill_in 'user_email', :with => users(:julien).email
    fill_in 'user_password', :with => 'secret'
    click_button 'user_submit'
    assert_equal user_path(users(:julien)), page.current_path
  end
end
