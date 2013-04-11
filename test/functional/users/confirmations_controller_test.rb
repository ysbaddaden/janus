require 'test_helper'

class Users::ConfirmationsControllerTest < ActionController::TestCase
  test "should get show with token" do
    users(:julien).generate_confirmation_token
    users(:julien).save!

    assert_difference('User.count(:confirmed_at)') do
      get :show, :confirm_token => users(:julien).confirmation_token
      assert_redirected_to root_url
      assert flash[:notice]
    end
  end

  test "should not get show without token" do
    assert_no_difference('User.count(:confirmed_at)') do
      get :show
      assert_response :ok
      assert_template 'new'
      assert_select '#error_explanation'
    end
  end

  test "should not get show with blank token" do
    assert_no_difference('User.count(:confirmed_at)') do
      get :show, :token => ""
      assert_response :ok
      assert_template 'new'
      assert_select '#error_explanation'
    end
  end

  test "should not get show with bad token" do
    users(:julien).generate_reset_password_token!

    assert_no_difference('User.count(:confirmed_at)') do
      get :show, :token => "aiorujfqptezjsmdguspfofkn"
      assert_response :ok
      assert_template 'new'
      assert_select '#error_explanation'
    end
  end

  test "should get new" do
    get :new
    assert_response :ok
    assert_select '#user_email', 1
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
end
