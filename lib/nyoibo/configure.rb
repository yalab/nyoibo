module Nyoibo
  module Configure
    attr_accessor :config
    def configure(&block)
      @config = Config.new
      @config.instance_exec(&block)
    end
  end

  class Config
    [:host, :port].each do |method|
      module_eval <<-EOS, __FILE__, __LINE__
        def #{method}(value = nil)
          (value) ? (@#{method} = value) : @#{method}
        end
      EOS
    end
  end
end
