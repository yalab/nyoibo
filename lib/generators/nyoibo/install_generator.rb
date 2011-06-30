module Nyoibo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates a Nyoibo initializer and copy locale files to your application."
      def copy_initializer
        template "nyoibo.rb", "config/initializers/nyoibo.rb"
      end
    end
  end
end
