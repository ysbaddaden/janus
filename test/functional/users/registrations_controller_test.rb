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
    post :create, :user => { :email => 'toto@example.com', :password => 'my secret' }
    assert_redirected_to user_url
    assert_authenticated(:user)
  end

  test "should create with confirmation" do
    post :create, :user => { :email => 'toto@example.com', :password => 'my secret', :password_confirmation => 'my secret' }
    assert_redirected_to user_url
    assert_authenticated(:user)
  end

  test "should not create with bad confirmation" do
    post :create, :user => { :email => 'toto@example.com', :password => 'my secret', :password_confirmation => '' }
    assert_response :ok
    assert_template 'users/registrations/new'
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
    put :update, :user => { :email => 'toto@example.com', :current_password => 'secret' }
    assert_redirected_to user_url
  end

  test "should not update without current_password" do
    sign_in users(:julien)
    put :update, :user => { :email => 'toto@example.com' }
    assert_response :ok
    assert_template 'users/registrations/edit'
  end

  test "should not update with bad current_password" do
    sign_in users(:julien)
    put :update, :user => { :email => 'toto@example.com', :current_password => 'bad secret' }
    assert_response :ok
    assert_template 'users/registrations/edit'
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
