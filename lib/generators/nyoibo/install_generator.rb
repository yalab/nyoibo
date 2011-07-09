require 'rails'
require 'rails/generators'

module Nyoibo
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates a Nyoibo initializer and copy javascript and locale files to your application."
      def copy_initializer
        template "nyoibo.rb.erb", "config/initializers/nyoibo.rb"
        template "nyoibo_en.yml", "config/locales/nyoibo_en.yml"
        template "nyoibo.js.coffee", "app/assets/javascripts/nyoibo.js.coffee"
        template "upload.js.coffee", "app/assets/javascripts/upload.js.coffee"
        copy_file "../../../../vendor/html5jp/progress.js", "app/assets/javascripts/progress.js"
        copy_file "../../../../vendor/web-socket-js/web_socket.js", "app/assets/javascripts/web_socket.js"
        copy_file "../../../../vendor/web-socket-js/swfobject.js", "app/assets/javascripts/swfobject.js"
        copy_file "../../../../vendor/web-socket-js/WebSocketMain.swf", "public/WebSocketMain.swf"
      end
    end
  end
end
