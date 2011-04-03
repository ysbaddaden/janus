require 'test_helper'

class Users::RemoteTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should remember user across sessions" do
    sign_in users(:julien), :remember_me => true
    assert_authenticated
    
    close_user_session
    
    visit root_url
    assert_authenticated
    
    sign_out :user
    
    visit root_url
    assert_not_authenticated
  end
end
