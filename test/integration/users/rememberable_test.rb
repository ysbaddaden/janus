require 'test_helper'

class Users::RememberableTest < ActionDispatch::IntegrationTest
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

  test "registration should remember user" do
    sign_up({ :email => 'toto@example.com', :password => 'my password' }, :scope => :user)
    assert_authenticated
    close_user_session
    
    visit root_url
    assert_authenticated
    
    sign_out :user
    visit root_url
    assert_not_authenticated
  end
end
