class ApplicationController < ActionController::Base
  include Janus::Helpers
  janus :user

  protect_from_forgery
end
