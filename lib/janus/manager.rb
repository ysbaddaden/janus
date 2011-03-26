module Janus
  class Manager
    include Janus::Hooks

    def initialize(request)
      @request = request
    end

    # Fetches the user from session.
    # 
    # Runs the after_authenticate(user, manager, options) callback before
    # actually returning the user.
    def authenticate(scope)
      Janus::Manager.run_callbacks(:authenticate, user(scope), self, :scope => scope)
      user(scope)
    end

    # Raises a Janus::NotAuthenticated exeception unless a user is authenticated.
    def authenticate!(scope)
      raise Janus::NotAuthenticated.new(scope) unless authenticate?(scope)
    end

    # Tries to authenticate the user before checking if it's authenticated.
    def authenticate?(scope)
      authenticate(scope) unless authenticated?(scope)
      authenticated?(scope)
    end

    # Returns true if a user is authenticated.
    def authenticated?(scope)
      !!session(scope)
    end

    # Logs a user in.
    # 
    # Runs the after_login(user, manager, options) callback.
    def login(user, options = {})
      options[:scope] ||= Janus.scope_for(user)
      set_user(user, options)
      Janus::Manager.run_callbacks(:login, user(options[:scope]), self, options)
    end

    # Logs a user out from the given scopes or from all scopes at once
    # if no scope is defined. If no scope is left the session will be resetted.
    # 
    # Runs the after_logout(user, manager, options) callback.
    def logout(*scopes)
      scopes ||= janus_sessions.keys
      
      scopes.each do |scope|
        unset_user(scope)
        Janus::Manager.run_callbacks(:logout, user(scope), self, :options => scope)
      end
      
      @request.reset_session if janus_sessions.empty?
    end

    # Manually sets a user without going throught the whole authentication
    # process. This is useful for keeping a user connected on multiple domains.
    def set_user(user, options = {})
      scope = options[:scope] || Janus.scope_for(user)
      janus_sessions[scope.to_sym] = [user.class.name, user.id]
    end

    # Manually removes the user without going throught the whole logout process.
    # This is useful for invalidating a session.
    def unset_user(scope)
      janus_sessions.delete(scope.to_sym)
      @users.delete(scope.to_sym) if @users
    end

    # Returns the currently connected user.
    def user(scope)
      @users ||= {}
      @users[scope.to_sym] = session(scope)[0].constantize.find(session(scope)[1]) if authenticated?(scope)
    end

    def session(scope)
      janus_sessions[scope.to_sym]
    end

    private
      def janus_sessions
        @request.session['janus'] ||= {}
      end
  end
end
