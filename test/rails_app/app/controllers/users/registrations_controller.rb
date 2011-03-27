class Users::RegistrationsController < Janus::RegistrationsController
  respond_to :html

  def after_sign_up_url(user)
    user_url
  end
end
