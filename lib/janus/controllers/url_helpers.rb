module Janus
  module UrlHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :session_url, :session_path, :new_session_url, :new_session_path, :destroy_session_url, :destroy_session_path,
        :registration_url, :registration_path, :new_registration_url, :new_registration_path, :edit_registration_url, :edit_registration_path,
        :confirmation_url, :confirmation_path, :new_confirmation_url, :new_confirmation_path,
        :password_url, :password_path, :new_password_url, :new_password_path, :edit_password_url, :edit_password_path
    end

    [:url, :path].each do |suffix|
      define_method("new_session_#{suffix}") do |scope, *args|
        send("new_#{scope}_session_#{suffix}", *args)
      end

      define_method("session_#{suffix}") do |scope, *args|
        send("#{scope}_session_#{suffix}", *args)
      end

      define_method("destroy_session_#{suffix}") do |scope, *args|
        send("destroy_#{scope}_session_#{suffix}", *args)
      end


      define_method("registration_#{suffix}") do |scope, *args|
        send("#{scope}_registration_#{suffix}", *args)
      end

      define_method("new_registration_#{suffix}") do |scope, *args|
        send("new_#{scope}_registration_#{suffix}", *args)
      end

      define_method("edit_registration_#{suffix}") do |scope, *args|
        send("edit_#{scope}_registration_#{suffix}", *args)
      end


      define_method("confirmation_#{suffix}") do |scope, *args|
        send("#{scope}_confirmation_#{suffix}", *args)
      end

      define_method("new_confirmation_#{suffix}") do |scope, *args|
        send("new_#{scope}_confirmation_#{suffix}", *args)
      end


      define_method("password_#{suffix}") do |scope, *args|
        send("#{scope}_password_#{suffix}", *args)
      end

      define_method("new_password_#{suffix}") do |scope, *args|
        send("new_#{scope}_password_#{suffix}", *args)
      end

      define_method("edit_password_#{suffix}") do |scope, *args|
        send("edit_#{scope}_password_#{suffix}", *args)
      end
    end
  end
end
