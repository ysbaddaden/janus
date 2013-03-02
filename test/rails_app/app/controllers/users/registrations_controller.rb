class Users::RegistrationsController < Janus::RegistrationsController
  respond_to :html

  def after_sign_up_url(user)
    user_url
  end

  def user_params
    if params.respond_to?(:permit)
      # Rails 4 (or Rails 3 + strong_parameters)
      params.require(:user).permit(:email, :current_password, :password, :password_confirmation)
    else
      # Rails 3
      params[:user].slice(:email, :current_password, :password, :password_confirmation)
    end
  end
end
