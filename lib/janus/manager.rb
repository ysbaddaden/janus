module Janus
  class Manager
    include Janus::Hooks
    include Janus::Strategies

    attr_reader :request, :cookies

    def initialize(request, cookies)
      @request, @cookies = request, cookies
    end

    # Tries to authenticate the user using strategies, before returning
    # the current user or nil.
    def authenticate(scope)
      run_strategies(scope) unless authenticated?(scope)
      user(scope)
    end

    # Raises a Janus::NotAuthenticated exception unless a user is authenticated.
    def authenticate!(scope)
      raise Janus::NotAuthenticated.new(scope) unless authenticate?(scope)
    end

    # Tries to authenticate the user before checking if it's authenticated.
    def authenticate?(scope)
      authenticate(scope)
      authenticated?(scope)
    end

    # Returns true if a user is authenticated.
    def authenticated?(scope) # :nodoc:
      !!session(scope)
    end

    # Logs a user in.
    # 
    # FIXME: what should happen when a user signs in but a user is already signed in?!
    def login(user, options = {})
      options[:scope] ||= Janus.scope_for(user)
      set_user(user, options)
      Janus::Manager.run_callbacks(:login, user, self, options)
    end

    # Logs a user out from the given scopes or from all scopes at once
    # if no scope is defined. If no scope is left after logout, then the
    # whole session will be resetted.
    def logout(*scopes)
      scopes = janus_sessions.keys if scopes.empty?
      
      scopes.each do |scope|
        _user = user(scope)
        unset_user(scope)
        Janus::Manager.run_callbacks(:logout, _user, self, :scope => scope)
      end
      
      request.reset_session if janus_sessions.empty?
    end

    # Manually sets a user without going throught the whole login or
    # authenticate process.
    def set_user(user, options = {})
      scope = options[:scope] || Janus.scope_for(user)
      janus_sessions[scope.to_sym] = { :user_class => user.class, :user_id => user.id }
    end

    # Manually removes the user without going throught the whole logout process.
    def unset_user(scope)
      janus_sessions.delete(scope.to_sym)
      @users.delete(scope.to_sym) unless @users.nil?
    end

    # Returns the currently connected user.
    def user(scope)
      scope = scope.to_sym
      @users ||= {}
      
      if authenticated?(scope)
        if @users[scope].nil?
          @users[scope] = session(scope)[:user_class].find(session(scope)[:user_id])
          Janus::Manager.run_callbacks(:fetch, @users[scope], self, :scope => scope)
        end
        
        @users[scope]
      end
    end

    # Returns the current session for user.
    def session(scope)
      janus_sessions[scope.to_sym]
    end

    private
      def janus_sessions
        request.session['janus'] ||= {}
      end
  end
end
