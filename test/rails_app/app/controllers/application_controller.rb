class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :main_site_host

  def main_site_host
    'www.example.com'
  end
end
