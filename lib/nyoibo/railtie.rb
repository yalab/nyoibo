require "nyoibo"
module Nyoibo
  class Railtie < Rails::Railtie
    config.after_initialize do
      Nyoibo.run
    end
  end
end
