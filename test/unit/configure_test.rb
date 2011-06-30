require 'test_helper'
class Nyoibo::ConfigureTest < Test::Unit::TestCase
  context ".configure" do
    setup do
      Nyoibo.configure do
        host 'localhost'
        port 3030
      end
    end
    should "reflect config" do
      assert_equal 'localhost', Nyoibo.config.host
      assert_equal 3030, Nyoibo.config.port
    end
  end
end
