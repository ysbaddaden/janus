class Admins::SessionsController < Janus::SessionsController
  respond_to :html

  def after_sign_in_url(admin)
    root_url
  end

  # def valid_remote_host?(host)
  #   ['www.example.com', 'test.host'].include?(host)
  # end
end
