require 'test_helper'

class Janus::ManagerTest < ActionController::TestCase
  test "should log user in and out" do
    @janus.login(users(:julien))
    assert @janus.authenticated?(:user), "Expected user to be authenticated."
    assert_equal users(:julien), @janus.user(:user)

    @janus.logout(:user)
    assert !@janus.authenticated?(:user), "Expected user to not be authenticated."
    assert_nil @janus.user(:user)
  end

  test "should log user in and out with custom scope" do
    @janus.login(users(:julien), :scope => :custom)
    assert @janus.authenticated?(:custom), "Expected user to be authenticated."
    assert_equal users(:julien), @janus.user(:custom)

    @janus.logout(:custom)
    assert !@janus.authenticated?(:custom), "Expected user to not be authenticated."
    assert_nil @janus.user(:custom)
  end

  test "should log users in different scopes" do
    @janus.login(users(:julien), :scope => :user)
    @janus.login(users(:martha), :scope => :admin)
    assert @janus.authenticated?(:user),  "Expected user to be authenticated."
    assert @janus.authenticated?(:admin), "Expected admin to be authenticated."
    assert_equal users(:julien), @janus.user(:user)
    assert_equal users(:martha), @janus.user(:admin)

    @janus.logout(:admin)
    assert  @janus.authenticated?(:user),  "Expected user to still be authenticated."
    assert !@janus.authenticated?(:admin), "Expected admin to no longer be authenticated."
    assert_equal users(:julien), @janus.user(:user)
    assert_nil @janus.user(:admin)
  end

  test "should logout all scopes at once" do
    @janus.login(users(:julien), :scope => :user)
    @janus.login(users(:martha), :scope => :admin)
    assert @janus.authenticated?(:user),  "Expected user to be authenticated."
    assert @janus.authenticated?(:admin), "Expected admin to be authenticated."

    @janus.logout
    assert !@janus.authenticated?(:user),  "Expected user to no longer be authenticated."
    assert !@janus.authenticated?(:admin), "Expected admin to no longer be authenticated."
  end

  test "should reset session after logout from last scope" do
    @janus.login(users(:julien), :scope => :user)
    @janus.login(users(:martha), :scope => :admin)

    @janus.logout(:admin)
    refute_nil session['janus']

    @janus.logout(:user)
    assert_nil session['janus']
  end

  test "should set and unset the user manually" do
    @janus.set_user(users(:martha))
    assert @janus.authenticated?(:user), "Expected user to be authenticated."
    assert_equal users(:martha), @janus.user(:user)

    @janus.unset_user(:user)
    assert !@janus.authenticated?(:user), "Expected user to not be authenticated."
    assert_nil @janus.user(:user)
  end

  test "should set and unset the user manually in different scopes" do
    @janus.set_user(users(:martha), :scope => :user)
    @janus.set_user(users(:julien), :scope => :admin)
    assert @janus.authenticated?(:user),  "Expected user to be authenticated."
    assert @janus.authenticated?(:admin), "Expected admin to be authenticated."
    assert_equal users(:martha), @janus.user(:user)
    assert_equal users(:julien), @janus.user(:admin)

    @janus.unset_user(:user)
    assert !@janus.authenticated?(:user),  "Expected user to no longer be authenticated."
    assert  @janus.authenticated?(:admin), "Expected admin to still be authenticated."
    assert_nil @janus.user(:user)
    assert_equal users(:julien), @janus.user(:admin)

    @janus.unset_user(:martha)
  end

  test "authenticate!" do
    assert_raise(Janus::NotAuthenticated) { @janus.authenticate!(:user) }

    @janus.set_user(users(:julien))
    assert_nothing_raised { @janus.authenticate!(:user) }
  end
end
