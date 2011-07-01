require "nyoibo"

class Nyoibo::Railtie < Rails::Railtie
  config.after_initialize do
    ENV["NYOIBO_ENV"] = Rails.env
    Nyoibo.run
  end
end
