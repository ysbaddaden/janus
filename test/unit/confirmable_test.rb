require 'test_helper'

class ConfirmableTest < ActiveSupport::TestCase
  setup do
    @user = users(:julien)
  end

  test "generate_confirmation_token" do
    @user.generate_confirmation_token
    assert_not_nil @user.confirmation_token
    assert_not_nil @user.confirmation_sent_at
    assert_nil @user.confirmed_at

    @user.reload
    assert_nil @user.confirmation_token
    assert_nil @user.confirmation_sent_at
    assert_nil @user.confirmed_at
  end

  test "confirm!" do
    @user.generate_confirmation_token
    @user.confirm!
    assert_nil @user.confirmation_token
    assert_nil @user.confirmation_sent_at
    assert_not_nil @user.confirmed_at
  end

  test "find_for_confirmation" do
    assert_nil User.find_for_confirmation(nil)
    assert_nil User.find_for_confirmation("amroiuzigsqjg")

    @user.generate_confirmation_token
    @user.save!
    assert_equal @user, User.find_for_confirmation(@user.confirmation_token)
  end
end
