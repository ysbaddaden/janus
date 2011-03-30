module Janus
  module Hooks
    extend ActiveSupport::Concern

    module ClassMethods
      def after_authenticate(&block)
        add_callback(:authenticate, block)
      end

      def after_login(&block)
        add_callback(:login, block)
      end

      def after_logout(&block)
        add_callback(:logout, block)
      end

      def run_callbacks(kind, *args)
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
