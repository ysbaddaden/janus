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

#  test "config" do
#    Janus.config do |config|
#      config.stretches = 15
#      config.pepper    = "0123456789"
#    end
#    
#    assert_equal 15, Janus.config.stretches
#    assert_equal "0123456789", Janus.config.pepper
#  end
end
