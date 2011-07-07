require 'test_helper'
class Nyoibo::CallbackTest < Test::Unit::TestCase
  class TestApp
    include Nyoibo::Callback
    after_upload "/" do
      "uploaded!"
    end
  end
  context "Run callback" do
    setup do
      @response = Nyoibo.run_callback("/")
    end
    should "fetch response" do
      assert_equal "uploaded!", @response
    end
  end
end
