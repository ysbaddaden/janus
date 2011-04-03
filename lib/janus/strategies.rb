module Janus
  module Strategies
    extend ActiveSupport::Concern

    # Runs authentication strategies to log a user in.
    # 
    # Runs the after_authenticate hook when a strategy succeeds.
    def run_strategies(scope)
      Janus::Manager.strategies.each { |name| break if run_strategy(name, scope) }
    end

    # Runs a given strategy and returns true if it succeeded.
    def run_strategy(name, scope)
      strategy = "Janus::Strategies::#{name.to_s.camelize}".constantize.new(request, scope)
      
      if strategy.valid?
        strategy.authenticate!
        
        if strategy.success?
          send(strategy.auth_method, strategy.user, :scope => scope)
          Janus::Manager.run_callbacks(:authenticate, strategy.user, self, :scope => scope)
        end
      end
      
      strategy.success?
    end

    module ClassMethods
      def strategies
        @strategies ||= [:remote_authenticatable]
      end
    end
  end
end
