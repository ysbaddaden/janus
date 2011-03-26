class Users::SessionsController < Janus::SessionsController
  def after_sign_in_url(user)
    user_url
  end
end
