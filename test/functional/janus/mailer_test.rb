require 'test_helper'

class Janus::MailerTest < ActionMailer::TestCase
  test "reset_password_instructions" do
    users(:julien).generate_reset_password_token!
    
    mail = JanusMailer.reset_password_instructions(users(:julien)).deliver
    assert_equal [users(:julien).email], mail.to
    assert !mail.subject.blank?
    
    url = edit_user_password_url(:token => users(:julien).reset_password_token)
    assert_match Regexp.new(Regexp.escape(url)), mail.encoded
  end
end
