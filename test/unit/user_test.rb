require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:julien)
  end

  test "valid_password?" do
    user = User.new(:password => "azerty")
    assert  user.valid_password?("azerty")
    assert !user.valid_password?("secret")
    
    assert @user.valid_password?('secret')
    assert users(:martha).valid_password?('vacances')
  end

  test "should validate current_password on update" do
    @user.update_attributes(:email => 'julien@example.fr', :current_password => 'secret')
    assert @user.persisted?, @user.errors.to_xml
    
    @user.update_attributes(:email => 'julien@example.fr', :current_password => 'bad secret')
    assert @user.errors[:current_password].any?, @user.errors.to_xml
  end

  test "password" do
    user = User.new(:password => "my pwd")
    assert_equal "my pwd", user.password
    assert_not_nil user.encrypted_password
  end

  test "should confirm password" do
    user = User.create(:password => "my pwd", :password_confirmation => "my pwd")
    assert user.errors[:password].empty?, user.errors.to_xml
    
    user = User.create(:password => "my pwd", :password_confirmation => "my PWD")
    assert user.errors[:password].any?, user.errors.to_xml
  end

  test "clean_up_passwords" do
    user = User.new(:email => 'julien@example.com', :password => 'abc', :password_confirmation => 'def')
    assert_not_nil user.email
    assert_not_nil user.password
    assert_not_nil user.password_confirmation
    
    user.clean_up_passwords
    assert_not_nil user.email
    assert_nil user.password
    assert_nil user.password_confirmation
  end

  test "should update" do
    @user.update_attributes(:email => 'julien@example.fr')
    assert @user.persisted?
  end

  test "session token" do
    @user.generate_session_token!
    assert_not_nil @user.session_token
    
    @user.destroy_session_token!
    assert_nil @user.session_token
  end

  test "find_for_database_authentication" do
    assert_equal @user, User.find_for_database_authentication(:email => @user.email)
    assert_equal users(:martha), User.find_for_database_authentication(:email => users(:martha).email)
  end

  test "find_for_remote_authentication" do
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
