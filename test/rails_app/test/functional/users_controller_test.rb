require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  [:julien, :martha].each do |name|
    test "#{name} should get show" do
      sign_in users(name)
      get :show
      assert_response :ok
      assert_select 'h1', 'Welcome ' + users(name).email
    end
  end

  test "should not get show" do
    get :show
    assert_redirected_to new_user_session_url
  end

  test "should not get show as xml" do
    get :show, :format => 'xml'
    assert_response :unauthorized
  end
end
