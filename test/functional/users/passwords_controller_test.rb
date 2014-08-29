# encoding: utf-8
require 'test_helper'

class Users::PasswordsControllerTest < ActionController::TestCase
  setup do
    @attributes = {
      :password => "azerty",
      :password_confirmation => "azerty"
    }
  end

  test "should get new" do
    get :new
    assert_response :ok
    assert_select '#user_email', 1
  end

  test "should get edit with token" do
    users(:julien).generate_reset_password_token!

    get :edit, :token => users(:julien).reset_password_token
    assert_response :ok
    assert_select '#user_reset_password_token', 1
    assert_select '#user_password', 1
    assert_select '#user_password_confirmation', 1
  end

  test "should not get edit without token" do
    get :edit
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should not get edit with blank token" do
    get :edit, :token => ''
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should not get edit with expired token" do
    users(:julien).generate_reset_password_token!
    users(:julien).update_attribute(:reset_password_sent_at, 1.month.ago)
    get :edit, :token => "aiorujfqptezjsmdguspfofkn"
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should not get edit with bad token" do
    users(:julien).generate_reset_password_token!

    get :edit, :token => "aiorujfqptezjsmdguspfofkn"
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should create" do
    assert_email do
      post :create, :user => { :email => users(:julien).email }
    end
    assert_redirected_to root_url
    assert flash[:notice]
  end

  test "should not create" do
    assert_no_email do
      post :create, :user => { :email => 'nobody@example.com' }
    end
    assert_response :ok
    assert_template 'new'
    assert_select '#error_explanation'
  end

  test "should update" do
    users(:julien).generate_reset_password_token!

    put :update, :user => @attributes.merge(
      :reset_password_token => users(:julien).reset_password_token
    )
    assert_redirected_to root_url
    assert flash[:notice]

    users(:julien).reload

    assert_nil users(:julien).reset_password_token
    assert_nil users(:julien).reset_password_sent_at
    assert users(:julien).valid_password?(@attributes[:password])
  end

  test "should logout when updating" do
    puts 'starting test'

    sign_in users(:martha)
    users(:julien).generate_reset_password_token!

    put :update, :user => @attributes.merge(
      :reset_password_token => users(:julien).reset_password_token
    )

    puts 'end of test'

    refute_equal users(:martha).id, (session['janus']['user']['user_id'] rescue nil)
  end

  test "should not update" do
    users(:julien).generate_reset_password_token!

    put :update, :user => @attributes.merge(
      :reset_password_token => users(:julien).reset_password_token,
      :password_confirmation => "qwerty"
    )
    assert_response :ok
    assert_template 'users/passwords/edit'
    assert_select '#error_explanation'

    users(:julien).reload

    assert_not_nil users(:julien).reset_password_token
    assert_not_nil users(:julien).reset_password_sent_at
    assert !users(:julien).valid_password?(@attributes[:password])
  end

  test "should not update without token" do
    put :update, :user => @attributes
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should not update with blank token" do
    put :update, :user => @attributes.merge(:reset_password_token => "")
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should not update with bad token" do
    put :update, :user => @attributes.merge(:reset_password_token => "zeouraprsoghpzçtusfgyzmpfojfjbsodifs")
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should not update with expired token" do
    users(:julien).generate_reset_password_token!
    users(:julien).update_attribute(:reset_password_sent_at, 1.month.ago)

    put :update, :user => @attributes.merge(:reset_password_token => users(:julien).reset_password_token)
    assert_redirected_to root_url
    assert flash[:alert]
  end

  test "should redirect to specified URL" do
    users(:julien).generate_reset_password_token!
    user_params = @attributes.merge(:reset_password_token => users(:julien).reset_password_token)

    put :update, :user => user_params, :return_to => 'http://example.com/some/path.html'
    assert_redirected_to 'http://example.com/some/path.html'
  end
end
