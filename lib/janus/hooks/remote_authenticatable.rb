Janus::Manager.after_login do |user, manager, options|
  if user.respond_to?(:generate_session_token!)
    user.generate_session_token! if user.session_token.nil?

    session = manager.session(options[:scope])
    session[:session_token] = user.session_token
  end
end

Janus::Manager.after_authenticate do |user, manager, options|
  if user.respond_to?(:session_token)
    session = manager.session(options[:scope])
    session[:session_token] = user.session_token
  end
end

Janus::Manager.after_logout do |user, manager, options|
  user.destroy_session_token! if user.respond_to?(:destroy_session_token!)
end

Janus::Manager.after_fetch do |user, manager, options|
  if user.respond_to?(:session_token)
    scope   = options[:scope]
    session = manager.session(scope)
    manager.unset_user(scope) unless session[:session_token] == user.session_token
  end
end
