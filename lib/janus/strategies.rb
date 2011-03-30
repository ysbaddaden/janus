module Janus
  module Strategies
    extend ActiveSupport::Concern

    # Runs authentication strategies to log a user in.
    # 
    # Runs the after_authenticate(user, manager, options) if user callback before
    # actually returning the user.
    def run_strategies(scope)
      Janus::Manager.strategies.each { |name| break if run_strategy(name, scope) }
    end

    # Runs a given strategy and returns true if it succeeded.
    def run_strategy(name, scope)
      strategy = "Janus::Strategies::#{name.to_s.camelize}".constantize.new(request, scope)
      
      if strategy.valid?
        strategy.authenticate!
        
        if strategy.success?
          login(strategy.user, :scope => scope)
          Janus::Manager.run_callbacks(:authenticate, strategy.user, self, :scope => scope)
        end
      end
      
      strategy.success?
    end

    module ClassMethods
      def strategies
        @strategies ||= []
      end
    end
  end
end
