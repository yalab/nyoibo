module Nyoibo
  module Daemon
    attr_reader :pid
    CMD_QUIT = /^QUIT$/
    CMD_JSON = /^JSON: /
    CMD_BASE64 = /^BASE64: /
    def run
      daemon = lambda{
        EventMachine::WebSocket.start(:host => config.host, :port => config.port) do |ws|
          ws.onopen{
            ws.send "OK Ready"
          }
          ws.onclose{
            ws.send "OK Bye"
          }
          ws.onmessage{|msg|
            @encoded ||= ""
            case msg
            when CMD_QUIT
              Nyoibo.run_callback(ws.request["path"], @json, Base64.decode64(@encoded))
              ws.close_connection
            when CMD_JSON
              msg.gsub!(CMD_JSON, '')
              @json = JSON.parse(msg)
              @json['size'] = @json['size'].to_i
              ws.send("NEXT")
            when CMD_BASE64
              msg.gsub!(CMD_BASE64, '')
              if msg.length > 0
                @encoded << msg
                ws.send("NEXT")
              else
                ws.send("EMPTY")
              end
            else
              ws.send("UNKNOWN")
            end
          }
        end
      }
      if ENV["Nyoibo_ENV"] == "test"
        daemon.call
      else
        @pid = Process.fork &daemon
      end
    end
  end
end
