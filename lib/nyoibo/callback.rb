module Nyoibo
  module Callback
    def self.callbacks
      @callbacks ||= {:before => {}, :after => {}}
    end
    def self.included(base)
      base.extend ClassMethod
    end

    module ClassMethod
      [:before, :after].each do |prefix|
        module_eval <<-EOS, __FILE__, __LINE__
          def #{prefix}_upload(path, &block)
            if ENV["NYOIBO_ENV"] == "production" && Nyoibo::Callback.callbacks[#{prefix}][path]
              raise "Already defined #{prefix} updated callback."
            end
            Nyoibo::Callback.callbacks[:#{prefix}][path] = block
            if ENV["NYOIBO_ENV"] == "development"
              Process.kill(:INT, Nyoibo.pid)
              Nyoibo.run
            end
          end
        EOS
      end
    end

    module Runner
      def run_callback(prefix, path="/", *args)
        block = Nyoibo::Callback.callbacks[prefix][path]
        block.call(*args) if block
      end
    end
  end
end
