require 'test_helper'

class JanusMailerTest < ActionMailer::TestCase
  test "reset_password_instructions" do
    users(:julien).generate_reset_password!
    
    mail = JanusMailer.reset_password_instructions(users(:julien))
    assert_equal [users(:julien).email], mail.to
    assert !mail.subject.blank?
    assert_match Regexp.new("a[href=" + edit_user_password_url(:token => users(:julien).reset_password_token) + "]"), mail.body
  end
end
