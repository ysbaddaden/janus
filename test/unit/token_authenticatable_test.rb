require 'test_helper'

class TokenAuthenticatableTest < ActiveSupport::TestCase
  setup { @user = users(:julien) }

  test "reset_authentication_token" do
    @user.reset_authentication_token
    assert @user.authentication_token_changed?
  end

  test "reset_authentication_token!" do
    token = @user.authentication_token
    @user.reset_authentication_token!
    refute @user.authentication_token_changed?
    refute_equal token, @user.authentication_token
  end

  test "find_for_token_authentication" do
    @user.reset_authentication_token!
    user = User.find_for_token_authentication(@user.authentication_token)
    assert_equal @user, user
  end

  test "find_for_token_authentication must destroy token" do
    @user.reset_authentication_token!

    User.stub(:reusable_authentication_token, false) do
      User.find_for_token_authentication(@user.authentication_token)
      assert_nil @user.reload.authentication_token
    end
  end

  test "find_for_token_authentication must keep token" do
    @user.reset_authentication_token!

    User.stub(:reusable_authentication_token, true) do
      User.find_for_token_authentication(@user.authentication_token)
      refute_nil @user.reload.authentication_token
    end
  end
end
