require 'test_helper'

class JanusTest < ActiveSupport::TestCase
  test "scope_for symbol" do
    assert_equal :user, Janus.scope_for(:user)
  end

  test "scope_for string" do
    assert_equal :user, Janus.scope_for("user")
  end

  test "scope_for object" do
    assert_equal :user, Janus.scope_for(User.new)
  end
end
