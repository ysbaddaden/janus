require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "find_for_database_authentication" do
    assert_equal users(:julien), User.find_for_database_authentication(:email => users(:julien).email)
    assert_equal users(:martha), User.find_for_database_authentication(:email => users(:martha).email)
  end

  test "valid_password?" do
    user = User.new(:password => "azerty")
    assert  user.valid_password?("azerty")
    assert !user.valid_password?("secret")
    
    assert users(:julien).valid_password?('secret')
    assert users(:martha).valid_password?('vacances')
  end

  test "should update" do
    users(:julien).update_attributes(:email => 'julien@example.fr')
  end

  test "find_for_remote_authentication" do
    flunk "should test find_for_remote_authentication"
  end
end
