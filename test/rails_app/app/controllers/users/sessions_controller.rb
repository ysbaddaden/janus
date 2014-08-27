class Users::SessionsController < Janus::SessionsController
  respond_to :html

  def after_sign_in_url(user)
    user_url
  end

  def valid_host?(host)
    super && host != "invalid.test.host"
  end

  def valid_remote_host?(host)
    ['www.example.com', 'test.host'].include?(host)
  end
end
