require 'test_helper'

class RemoteAuthenticatableTest < ActiveSupport::TestCase
  setup do
    @user = users(:julien)
  end

  test "session token" do
    @user.generate_session_token!
    assert_not_nil @user.session_token
    
    @user.destroy_session_token!
    assert_nil @user.session_token
  end

  test "find_for_remote_authentication" do
    assert_nil User.find_for_remote_authentication(nil)
    assert_nil User.find_for_remote_authentication(" ")
    
    token1 = token2 = nil
    
    assert_difference('RemoteToken.count', 2) do
      token1 = @user.generate_remote_token!
      token2 = @user.generate_remote_token!
    end
    
    assert_difference('RemoteToken.count', -1) do
      assert_equal @user, User.find_for_remote_authentication(token1)
      assert_nil User.find_for_remote_authentication(token1)
    end
    
    assert_difference('RemoteToken.count', -1) do
      assert_equal @user, User.find_for_remote_authentication(token2)
      assert_nil User.find_for_remote_authentication(token2)
    end
  end
end
