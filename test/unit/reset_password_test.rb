require 'test_helper'

class ResetPasswordTest < ActiveSupport::TestCase
  setup do
    @user = users(:julien)
  end

  test "generate reset password token" do
    assert @user.generate_reset_password_token!
    assert @user.persisted?
    refute_nil @user.reset_password_token
    refute_nil @user.reset_password_sent_at
  end

  test "reset password" do
    assert @user.generate_reset_password_token!
    assert @user.reset_password!('password' => "azerty", 'password_confirmation' => "azerty")
    assert @user.persisted?
    assert_nil @user.reset_password_token
    assert_nil @user.reset_password_sent_at
    assert @user.valid_password?("azerty")
  end

  test "should find user with token" do
    @user.generate_reset_password_token!
    user = User.find_for_password_reset(@user.reset_password_token)
    assert_equal @user, user
    refute_nil user.reset_password_token
    refute_nil user.reset_password_sent_at
  end

  test "should not find user with bad tokens" do
    assert_nil User.find_for_password_reset(nil)
    assert_nil User.find_for_password_reset("ariualfknsmgojqm")
  end

  test "token expiration" do
    @user.generate_reset_password_token!
    @user.update_attribute(:reset_password_sent_at, 1.week.ago)
    assert_nil User.find_for_password_reset(@user.reset_password_token)
    @user.reload
    assert_nil @user.reset_password_token
    assert_nil @user.reset_password_sent_at
  end
end
