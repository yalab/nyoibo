require 'test_helper'
class Nyoibo::DaemonTest < Test::Unit::TestCase
  class TestApp < Test::Unit::TestCase
    include Nyoibo::Callback
    after_upload "/" do |json, binary|
      File.open("/tmp/test.jpg", "w:binary"){|f|
        f.write(binary)
      }
      raise "finame is not 'test.jpg'" if json["filename"] != "test.jpg"
      raise "Binary size is not '3137' byte" if binary.length != 3137
    end
  end

  context "run" do
    setup do
      @file = File.new(File.expand_path("../../fixtures/test.jpg", __FILE__), "rb")
      Nyoibo.configure do
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
              if @start == @encoded.size
                http.send("QUIT")
              else
                chunk = @encoded.slice(@start..@end)
                if @start == 0
                  chunk = "data:application/octet-stream;base64," + chunk
                end

                http.send(chunk)
              end
              @start = @end + 1
            end
          }
          http.disconnect{
            EventMachine.stop
          }
        end
        Nyoibo.run
      end
    end
  end
end
