module Janus
  module Strategies
    extend ActiveSupport::Concern

    # Runs authentication strategies to log a user in.
    def run_strategies(scope)
      Janus::Manager.strategies.each { |name| break if run_strategy(name, scope) }
    end

    # Runs a given strategy and returns true if it succeeded.
    def run_strategy(name, scope)
      strategy = "Janus::Strategies::#{name.to_s.camelize}".constantize.new(scope, self)

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
      # Returns the list of strategies as underscore symbols.
      def strategies
        @strategies ||= [:rememberable, :remote_authenticatable]
      end
    end
  end
end
