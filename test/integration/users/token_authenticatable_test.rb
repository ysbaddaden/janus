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

  test "should not sign user with invalid token" do
    visit root_url(:auth_token => 'unknown token')
    refute_authenticated
  end

  test "should reuse token" do
    Janus::Config.stub(:reusable_authentication_token, true) do
      token = @user.authentication_token
      visit root_url(:auth_token => token)
      sign_out :user

      visit root_url(:auth_token => token)
      assert_authenticated
    end
  end

  test "shouldn't reuse token" do
    Janus::Config.stub(:reusable_authentication_token, false) do
      token = @user.authentication_token
      visit root_url(:auth_token => token)
      sign_out :user

      visit root_url(:auth_token => token)
      refute_authenticated
    end
  end
end
