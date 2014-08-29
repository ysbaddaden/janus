require 'test_helper'

class TrackableTest < ActiveSupport::TestCase
  test "track!" do
    users(:julien).track!('127.0.0.1')
    users(:julien).reload

    assert_nil     users(:julien).last_sign_in_at
    assert_nil     users(:julien).last_sign_in_ip
    refute_nil users(:julien).current_sign_in_at
    assert_equal '127.0.0.1', users(:julien).current_sign_in_ip

    users(:julien).track!('127.0.0.2')
    users(:julien).reload

    refute_nil users(:julien).last_sign_in_at
    refute_nil users(:julien).last_sign_in_ip
    refute_nil users(:julien).current_sign_in_at
    assert_equal '127.0.0.2', users(:julien).current_sign_in_ip
  end
end
