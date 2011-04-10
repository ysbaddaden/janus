Janus::Manager.after_login do |user, manager, options|
  user.track!(manager.request.remote_ip) if user.respond_to?(:track!)
end
