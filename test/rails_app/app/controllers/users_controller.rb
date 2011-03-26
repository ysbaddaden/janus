class UsersController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :xml

  def show
    respond_with(current_user)
  end

  def after_sign_in_url(user)
    user_url
  end
end
