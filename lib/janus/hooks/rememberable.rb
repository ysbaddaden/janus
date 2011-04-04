Janus::Manager.after_login do |user, manager, options|
  if options[:rememberable] && user.respond_to?(:remember_me!)
    user.remember_me!
    
    remember_cookie_name = Janus::Strategies::Rememberable.remember_cookie_name(options[:scope])
    manager.cookies[remember_cookie_name] = {
      :value => user.remember_token,
      :expires => user.class.remember_for.from_now
    }
  end
end

Janus::Manager.after_logout do |user, manager, options|
  if user.respond_to?(:forget_me!)
    user.forget_me!
    
    remember_cookie_name = Janus::Strategies::Rememberable.remember_cookie_name(options[:scope])
    manager.cookies.delete(remember_cookie_name)
  end
end
