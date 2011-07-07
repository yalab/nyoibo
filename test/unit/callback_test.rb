require 'test_helper'
class Nyoibo::CallbackTest < Test::Unit::TestCase
  class TestApp
    include Nyoibo::Callback
    after_upload "/" do
      "uploaded!"
    end
    before_upload '/' do
      "before"
    end
  end
  context "Run after callback" do
    setup do
      @response = Nyoibo.run_callback(:after, "/")
    end
    should "fetch response" do
      assert_equal "uploaded!", @response
    end
  end
  context "Run before callback" do
    setup do
      @response = Nyoibo.run_callback(:before, "/")
    end
    should "fetch response" do
      assert_equal "before", @response
    end
  end
end
