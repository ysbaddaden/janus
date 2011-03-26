require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "find_for_database_authentication" do
    assert_equal users(:julien), User.find_for_database_authentication(:email => users(:julien).email)
    assert_equal users(:martha), User.find_for_database_authentication(:email => users(:martha).email)
  end

  test "valid_password?" do
    assert users(:julien).valid_password?('secret')
    assert users(:martha).valid_password?('vacances')
  end
end
