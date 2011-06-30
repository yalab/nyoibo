require 'test_helper'
class Nyoibo::DaemonTest < Test::Unit::TestCase
  context "run" do
    setup do
      @file = File.new(File.expand_path("../../fixtures/test.jpg", __FILE__), "rb")
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
          @start = 0
          @sendsize = 1024
          http.stream{|msg|
            case  msg
            when "OK Ready"
              http.send("JSON: " + {:filename => File.basename(@file.path), :size => @file.size}.to_json)
            when "NEXT"
              @end = @start + @sendsize
              @encoded ||= Base64.encode64(@file.read)
              @end = @encoded.size - 1 if @end >= @encoded.size
              http.send('BASE64: ' + @encoded.slice(@start...@end))
              @start = @end + 1
              http.send("QUIT") if @start >= @encoded.size
            when "OK Bye"
              EventMachine.stop
            end
          }
        end
        Nyoibo.run
      end
    end
  end
end
