require 'test_helper'
class Nyoibo::DaemonTest < Test::Unit::TestCase
  context "run" do
    setup do
      Nyoibo.configuration do
        host "localhost"
        port 3030
      end
    end

    should "listen port" do
      EM.run do
        EventMachine.add_timer(0.1) do
          http = EventMachine::HttpRequest.new('ws://localhost:3030/').get(:timeout => 0)
          http.errback { failed }
          http.callback { http.close_connection }
          http.stream{|msg|
            assert_equal "OK Ready", msg
          }
        end
        Nyoibo.run
      end
    end
  end
end
