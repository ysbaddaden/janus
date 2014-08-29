require 'test_helper'

class RemoteTokenTest < ActiveSupport::TestCase
  test "should create" do
    remote_token = RemoteToken.create(:user => users(:julien))
    assert remote_token.persisted?, remote_token.errors.to_xml
    refute_nil remote_token.token
  end
end
