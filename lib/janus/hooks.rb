module Janus
  module Hooks
    extend ActiveSupport::Concern

    module ClassMethods
      def after_authenticate(&block)
        set_callback(:authenticate, block)
      end

      def after_login(&block)
        set_callback(:login, block)
      end

      def after_logout(&block)
        set_callback(:logout, block)
      end

      def run_callbacks(kind, *args)
        _callbacks(kind).each { |block| block.call(*args) }
      end

      private
        def set_callback(kind, block)
          _callbacks(kind) << block
        end

        def _callbacks(kind)
          @_callbacks ||= {}
          @_callbacks[kind] ||= []
        end
    end
  end
end
