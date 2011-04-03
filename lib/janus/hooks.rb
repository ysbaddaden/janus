module Janus
  module Hooks # :nodoc:
    extend ActiveSupport::Concern

    # Hooks allow you the react at the different steps of a user session.
    # All callbacks will receive the same arguments: +user+, +manager+ and
    # +options+.
    # 
    # Example:
    # 
    #   Janus::Manager.after_login do |user, manager, options|
    #     session = manager.session(options[:scope])
    #     
    #     # write some great code here
    #   end
    # 
    # Options:
    # 
    # - +:scope+
    # 
    module ClassMethods
      # Executed after a strategy succeeds to authenticate a user.
      def after_authenticate(&block)
        add_callback(:authenticate, block)
      end

      # Executed the first time an authenticated user is fetched from session.
      def after_fetch(&block)
        add_callback(:fetch, block)
      end

      # Executed after a user is logged in.
      def after_login(&block)
        add_callback(:login, block)
      end

      # Executed after a user is logged out. after_logout will be executed for
      # each scope when logging out from multiple scopes at once.
      def after_logout(&block)
        add_callback(:logout, block)
      end

      def run_callbacks(kind, *args) # :nodoc:
        callbacks(kind).each { |block| block.call(*args) }
      end

      private
        def add_callback(kind, block)
          callbacks(kind) << block
        end

        def callbacks(kind)
          @callbacks ||= {}
          @callbacks[kind] ||= []
        end
    end
  end
end
