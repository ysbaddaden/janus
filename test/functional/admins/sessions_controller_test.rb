require 'test_helper'

class Admins::SessionsControllerTest < ActionController::TestCase
  setup do
    @valid = { :email => admins(:bob).email, :password => 'secret' }
  end

  test "return_to when passwords_controller is missing" do
    post :create, :admin => @valid
    assert_redirected_to root_url
    assert_authenticated(:admin)
  end
end
