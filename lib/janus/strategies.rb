module Janus
  module Strategies
    extend ActiveSupport::Concern

    # Runs authentication strategies to log a user in.
    # 
    # Runs the after_authenticate(user, manager, options) if user callback before
    # actually returning the user.
    def run_strategies(scope)
      Janus::Manager.strategies.each do |klass|
        strategy = klass.new(@request, scope)
        strategy.authenticate!
        
        if strategy.success?
          login(strategy.user, :scope => scope)
          Janus::Manager.run_callbacks(:authenticate, strategy.user, self, :scope => scope)
          return
        end
      end
    end

    module ClassMethods
      def strategies
        @strategies ||= [Janus::Strategies::Rememberable]
      end
    end
  end
end
