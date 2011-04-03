Warden::Manager.after_login do |user, manager, options|
  if options[:rememberable] && user.respond_to?(:remember_me!)
    user.remember_me!
    manager.request.cookies["remember_#{options[:scope]}_token"] = user.remember_token
  end
end
