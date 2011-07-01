require "nyoibo"
module Nyoibo
  class Railtie < Rails::Railtie
    config.after_initialize do
      ENV["NYOIBO_ENV"] = Rails.env
      Nyoibo.run
      ApplicationController.send(:helper, NyoiboHelper)
    end
  end
end
