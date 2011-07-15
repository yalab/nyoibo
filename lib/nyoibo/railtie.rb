require "nyoibo"

class Nyoibo::Railtie < Rails::Railtie
  config.after_initialize do
    ENV["NYOIBO_ENV"] = Rails.env
    if Rails.env != "test" && !defined?(::Rake)
      Nyoibo.run
      ::ApplicationController.send(:prepend_before_filter, lambda{
                                     if Rails.env == "development"
                                       Process.kill(:INT, Nyoibo.pid)
                                       Nyoibo.run
                                     end
                                     true})
    end
  end
end
