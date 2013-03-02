require 'test_helper'

class RememberableTest < ActiveSupport::TestCase
  setup do
    @user = users(:julien)
  end

  test "remember_token" do
    @user.remember_me!
    assert_not_nil @user.remember_token
    assert_not_nil @user.remember_created_at

    @user.forget_me!
    assert_nil @user.remember_token
    assert_nil @user.remember_created_at
  end

  test "should not remember across browsers" do
    @user.remember_me!
    token = @user.remember_token
    created_at = @user.remember_created_at

    @user.remember_me!
    assert_not_equal token, @user.remember_token
    assert_not_equal created_at, @user.remember_created_at
  end

  test "find_for_remember_authentication" do
    assert_nil User.find_for_remember_authentication(nil)
    assert_nil User.find_for_remember_authentication(" ")

    @user.remember_me!
    token = @user.remember_token

    assert_equal @user, User.find_for_remember_authentication(token)
    assert_equal @user, User.find_for_remember_authentication(token)

    @user.remember_me!
    assert_nil User.find_for_remember_authentication(token), "token should no longer be valid"

    @user.forget_me!
    assert_nil User.find_for_remember_authentication(token), "token should have been erased"
  end

  test "expiration" do
    @user.remember_me!
    @user.update_attribute(:remember_created_at, 1.year.ago)
    assert_nil User.find_for_remember_authentication(@user.remember_token)
  end
end
