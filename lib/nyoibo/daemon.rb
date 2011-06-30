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
          ws.onmessage{|msg|
            @binary ||= ""
            case msg
            when CMD_QUIT
              ws.send("OK Bye")
              # p ws.request["path"]
              EventMachine.stop
            when CMD_JSON
              msg.gsub!(CMD_JSON, '')
              @json = JSON.parse(msg)
              @json['size'] = @json['size'].to_i
              ws.send("NEXT")
            when CMD_BASE64
              msg.gsub!(CMD_BASE64, '')
              @binary << Base64.decode64(msg)
              ws.send("NEXT")
            else
              #FIXME
              ws.send("QUIT")
            end
          }
        end
      }
      if ENV["Nyoibo_ENV"] == "test"
        daemon.call
      else
        @pid = Process.fork daemon
      end
    end
  end
end
