require 'test_helper'

class Users::RemoteTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "service login" do
    # user visits a remote site
    visit blog_url(:host => 'test.host')
    assert_not_authenticated

    # user clicks the sign in link
    click_link 'sign_in'
    assert_match Regexp.new('^' + Regexp.quote(new_user_session_url(:return_to => '')) + '.+'), current_url
    assert_select 'input[name=return_to]'
    assert_select '#user_email'
    assert_select '#user_password'

    # user signs in and should be redirected to remote site
    fill_in 'user_email', :with => users(:julien).email
    fill_in 'user_password', :with => 'secret'
    find('input[name=commit]').click
    assert_match Regexp.new('^' + Regexp.quote(blog_url(:host => 'test.host', :remote_token => '')) + '.+'), current_url

    # user should be authenticated on remote site
    assert_authenticated
  end

  test "service login with signed in user" do
    # user signs in on main site
    sign_in users(:julien)

    # user visits a remote site
    visit blog_url(:host => 'test.host')
    assert_not_authenticated

    # user clicks the sign in link of remote site which should redirect her back
    click_link 'sign_in'
    assert_match Regexp.new('^' + Regexp.quote(blog_url(:host => 'test.host', :remote_token => '')) + '.+'), current_url

    # user should have been transparently logged in
    assert_authenticated
  end

  test "single sign out" do
    # user signs in on main and remote site
    sign_in users(:julien)
    service_login :user, :return_to => root_url(:host => 'test.host')

    # user signs out from main site
    sign_out :user

    # somebody visits the remote site using the user session
    visit root_url(:host => 'test.host')

    # session should have been invalidated
    assert_not_authenticated
  end

  test "session invalidation should not reset the user session_token" do
    sign_in users(:julien)
    service_login :user, :return_to => root_url(:host => 'test.host')

    sign_out :user
    sign_in users(:julien)

    visit root_url(:host => 'test.host')
    assert_not_authenticated

    visit root_url
    assert_authenticated
  end
end
