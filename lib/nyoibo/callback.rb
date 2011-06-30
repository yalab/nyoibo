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
          logger = Logger.new(STDERR)
          logger.warn "Already defined '#{path}' updated callback."
        end
        Nyoibo::Callback.callbacks[path] = block
      end
    end

    module Runner
      def run_callback(path="/", *args)
        block = Nyoibo::Callback.callbacks[path]
        block.call(*args)
      end
    end
  end
end
