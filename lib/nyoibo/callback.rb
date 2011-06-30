module Nyoibo
  module Callback
    def self.callbacks
      @callbacks ||= {}
    end
    def self.included(base)
      base.extend ClassMethod
    end

    module ClassMethod
      def uploaded(path, &block)
        if Nyoibo::Callback.callbacks[path]
          raise "Already defined '#{path}' updated callback."
        end
        Nyoibo::Callback.callbacks[path] = block
      end
    end

    module Runner
      def run_callback(path="/")
        block = Nyoibo::Callback.callbacks[path]
        block.call
      end
    end
  end
end
