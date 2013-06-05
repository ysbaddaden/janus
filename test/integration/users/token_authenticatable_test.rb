require 'test_helper'

class Users::TokenAuthenticatableTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @user = users(:julien)
    @user.reset_authentication_token!
  end

  test "should sign user in from token" do
    visit root_url(:auth_token => @user.authentication_token)
    assert_authenticated
  end

  test "should not sign user with invalid auth token" do
    visit root_url(:auth_token => 'unknown token')
    assert_not_authenticated
  end
end
