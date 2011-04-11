require 'test_helper'

class Users::SessionsControllerTest < ActionController::TestCase
  setup do
    @valid = { :email => users(:julien).email, :password => 'secret' }
  end

  test "should get new" do
    get :new
    assert_response :ok
    assert_select '#user_email', 1
    assert_select '#user_password', 1
    assert_select 'input[name=return_to]', 0
  end

  test "new should pass return_to" do
    get :new, :return_to => root_path
    assert_response :ok
    assert_select '#user_email', 1
    assert_select '#user_password', 1
    assert_select 'input[name=return_to][value=' + root_path + ']', 1
  end

  test "should create" do
    post :create, :user => @valid
    assert_redirected_to user_url
    assert_authenticated(:user)
  end

  test "should create and redirect to given path" do
    post :create, :user => @valid, :return_to => blog_path
    assert_redirected_to blog_path
    assert_authenticated(:user)
  end

  test "should create and redirect to given URL" do
    post :create, :user => @valid, :return_to => root_url
    assert_redirected_to root_url
    assert_authenticated(:user)
  end

  test "create should not redirect to unknown host" do
    post :create, :user => @valid, :return_to => root_url(:host => 'www.bad-host.com')
    assert_redirected_to user_url
    assert_authenticated(:user)
  end

  test "should fail to create without password" do
    post :create, :user => { :email => users(:julien).email, :password => '' }
    assert_response :unauthorized
    assert_template 'users/sessions/new'
    assert_select "#user_email[value='" + users(:julien).email + "']"
    assert_select "#user_password[value='secret']", 0
    assert_select '#error_explanation'
    assert_not_authenticated(:user)
  end

  test "should fail to create with bad password" do
    post :create, :user => { :email => users(:martha).email, :password => 'force me in' }
    assert_response :unauthorized
    assert_template 'users/sessions/new'
    assert_select "#user_email[value='" + users(:martha).email + "']"
    assert_select "#user_password[value='force me in']", 0
    assert_select '#error_explanation'
    assert_not_authenticated(:user)
  end

  test "should fail to create with unknown user" do
    post :create, :user => { :email => 'nobody@localhost', :password => 'secret' }
    assert_response :unauthorized
    assert_template 'users/sessions/new'
    assert_select "#user_email[value='nobody@localhost']"
    assert_select "#user_password[value='secret']", 0
    assert_select '#error_explanation'
    assert_not_authenticated(:user)
  end

  test "should destroy" do
    sign_in users(:julien)
    
    get :destroy
    assert_redirected_to root_url
    assert_not_authenticated(:user)
  end

  test "destroy should silently logout anonymous" do
    get :destroy
    assert_redirected_to root_url
    assert_not_authenticated(:user)
  end
end
