require 'test_helper'

class Users::SessionsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "sign in and out" do
    visit new_user_session_path
    fill_in 'user_email', :with => users(:julien).email
    fill_in 'user_password', :with => 'secret'
    find('input[name=commit]').click
    
    assert_equal user_path, page.current_path
    find('h1').has_content?('Welcome ' + users(:julien).email)
    
    visit destroy_user_session_path
    assert_equal root_path, page.current_path
  end
end
