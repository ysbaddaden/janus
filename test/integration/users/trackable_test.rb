require 'test_helper'

class Users::TrackableTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "should track user" do
    current_sign_in_at = users(:julien).reload.current_sign_in_at
    sign_in users(:julien)
    assert_not_equal current_sign_in_at, users(:julien).reload.current_sign_in_at
  end

  test "remote authentication should not track user" do
    sign_in users(:julien)

    current_sign_in_at = users(:julien).reload.current_sign_in_at

    visit root_url(:host => 'test.host')
    click_link 'sign_in'

    assert_equal current_sign_in_at, users(:julien).reload.current_sign_in_at
  end
end
