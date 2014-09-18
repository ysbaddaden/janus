require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:julien)
  end

  test "valid_password?" do
    user = User.new(:password => "azerty")
    refute user.valid_password?("secret")
    assert user.valid_password?("azerty")
    refute user.valid_password?("secret")

    assert @user.valid_password?('secret')
    assert users(:martha).valid_password?('vacances')
  end

  test "valid_password? with scrypt" do
    with_encryptor :scrypt do
      user = User.new(:password => "a good secret")
      assert user.valid_password?("a good secret")
      refute user.valid_password?("some lame guessing")
    end
  end

  test "valid_password? without encrypted password" do
    refute User.new.valid_password?("")
    refute User.new.valid_password?("secret")

    with_encryptor :scrypt do
      refute User.new.valid_password?("")
      refute User.new.valid_password?("some lame guessing")
    end
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
    refute_nil user.encrypted_password
  end

  test "should confirm password" do
    user = User.create(:password => "my pwd", :password_confirmation => "my pwd")
    assert user.errors[:password].empty?, user.errors.to_xml

    user = User.create(:password => "my pwd", :password_confirmation => "my PWD")
    assert user.errors[:password].any? || user.errors[:password_confirmation].any?, user.errors.to_xml
  end

  test "clean_up_passwords" do
    user = User.new(:email => 'julien@example.com', :password => 'abc', :password_confirmation => 'def')
    refute_nil user.email
    refute_nil user.password
    refute_nil user.password_confirmation

    user.clean_up_passwords
    refute_nil user.email
    assert_nil user.password
    assert_nil user.password_confirmation
  end

  test "should update" do
    @user.update_attributes(:email => 'julien@example.fr')
    assert @user.persisted?
  end

  test "find_for_database_authentication" do
    assert_equal @user, User.find_for_database_authentication(:email => @user.email)
    assert_equal users(:martha), User.find_for_database_authentication(:email => users(:martha).email)
  end
end
