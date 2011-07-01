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
        if ENV["NYOIBO_ENV"] == "production" && Nyoibo::Callback.callbacks[path]
          raise "Already defined '#{path}' updated callback."
        end
        Nyoibo::Callback.callbacks[path] = block

        Process.kill(:TERM, Nyoibo.pid) && Nyoibo.run if ENV["NYOIBO_ENV"] == "development"
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
