require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :ok
    assert_select '#user_email'
    assert_select '#user_password'
    assert_select '#user_password_confirmation'
  end

  test "should create" do
    assert_email do
      post :create, :user => { :email => 'toto@example.com', :password => 'my secret' }
      assert_redirected_to user_url
      assert_authenticated(:user)
    end
  end

  test "should create with password confirmation" do
    assert_email do
      post :create, :user => { :email => 'toto@example.com', :password => 'my secret', :password_confirmation => 'my secret' }
      assert_redirected_to user_url
      assert_authenticated(:user)
    end
  end

  test "should not create with bad confirmation" do
    assert_no_email do
      post :create, :user => { :email => 'toto@example.com', :password => 'my secret', :password_confirmation => 'blah' }
      assert_response :ok
      assert_template 'users/registrations/new'
    end
    
    assert_select   '#error_explanation'
    assert_select   "#user_password", 1
    assert_select   "#user_password[value]", 0
    assert_select   "#user_password_confirmation", 1
    assert_select   "#user_password_confirmation[value]", 0
  end

  test "should get edit" do
    sign_in users(:julien)
    get :edit
    assert_response :ok
    assert_select '#user_email'
    assert_select '#user_current_password'
    assert_select '#user_password'
    assert_select '#user_password_confirmation'
  end

  test "should update" do
    sign_in users(:julien)
    
#    assert_email do
      put :update, :user => { :email => 'toto@example.com', :current_password => 'secret' }
      assert_redirected_to user_url
#    end
  end

  test "should update with blank passwords" do
    sign_in users(:julien)
    put :update, :user => { :email => 'toto@example.com', :current_password => 'secret',
      :password => "", :password_confirmation => "" }
    assert_redirected_to user_url
    assert users(:julien).valid_password?('secret')
  end

  test "should not update without current_password" do
    sign_in users(:julien)
    put :update, :user => { :email => 'toto@example.com' }
    assert_response :ok
    assert_template 'users/registrations/edit'
    assert_select   '#error_explanation'
  end

  test "should not update with bad current_password" do
    sign_in users(:julien)
    put :update, :user => { :email => 'toto@example.com', :current_password => 'bad secret',
      :password => "azerty", :password_confirmation => "azerty" }
    assert_response :ok
    assert_template 'users/registrations/edit'
    assert_select   '#error_explanation'
    assert_select   '#user_current_password'
    assert_select   '#user_current_password[value]', 0
    assert_select   '#user_password'
    assert_select   '#user_password[value]', 0
    assert_select   '#user_password_confirmation'
    assert_select   '#user_password_confirmation[value]', 0
  end

  test "should destroy" do
    sign_in users(:julien)
    delete :destroy
    assert_redirected_to root_url
  end

  test "anonymous should not get edit" do
    get :edit
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not update" do
    put :update, :user => { :email => 'toto@example.com', :current_password => 'bad secret' }
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not destroy" do
    delete :destroy
    assert_redirected_to new_user_session_url
  end
end
