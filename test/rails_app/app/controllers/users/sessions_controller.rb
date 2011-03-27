class Users::SessionsController < Janus::SessionsController
  respond_to :html

  def after_sign_in_url(user)
    user_url
  end
end
