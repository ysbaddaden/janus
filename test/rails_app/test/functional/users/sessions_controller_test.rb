require 'test_helper'

class Users::SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :ok
    assert_select '#user_email', 1
    assert_select '#user_password', 1
  end

  test "should create" do
    post :create, :user => { :email => users(:julien).email, :password => 'secret' }
    assert_redirected_to user_url
    assert_authenticated(:user)
  end

  test "should fail to create without password" do
    post :create, :user => { :email => users(:julien).email, :password => '' }
    assert_response :unauthorized
    assert_template 'users/sessions/new'
    assert_select "#user_email[value='" + users(:julien).email + "']"
    assert_select "#user_password[value='secret']", 0
    assert_not_authenticated(:user)
  end

  test "should fail to create with bad password" do
    post :create, :user => { :email => users(:martha).email, :password => 'force me in' }
    assert_response :unauthorized
    assert_template 'users/sessions/new'
    assert_select "#user_email[value='" + users(:martha).email + "']"
    assert_select "#user_password[value='force me in']", 0
    assert_not_authenticated(:user)
  end

  test "should fail to create with unknown user" do
    post :create, :user => { :email => 'nobody@localhost', :password => 'secret' }
    assert_response :unauthorized
    assert_template 'users/sessions/new'
    assert_select "#user_email[value='nobody@localhost']"
    assert_select "#user_password[value='secret']", 0
    assert_not_authenticated(:user)
  end

  test "should destroy" do
    get :destroy
    assert_redirected_to root_url
    assert_not_authenticated(:user)
  end

  test "should destroy user" do
    post :create, :user => { :email => users(:julien).email, :password => 'secret' }
    assert_authenticated(:user)
    
    get :destroy
    assert_redirected_to root_url
    assert_not_authenticated(:user)
  end
end
