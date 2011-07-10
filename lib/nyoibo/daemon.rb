module Nyoibo
  module Daemon
    attr_reader :pid
    CMD_QUIT = /^QUIT$/
    CMD_JSON = /^JSON: /
    TYPE_BASE64 = %r|^data:application/octet-stream;base64,|
    def run
      return if defined?(IRB)
      return unless defined?(config)
      daemon = lambda{
        EventMachine::WebSocket.start(:host => config.host, :port => config.port) do |ws|
          ws.onopen{
            ws.send "OK Ready"
          }
          ws.onclose{
            ws.close_websocket
          }
          ws.onmessage{|msg|
            @binary ||= ""
            @binary_type ||= 'binary'
            case msg
            when CMD_QUIT
              if @binary_type == 'base64'
                @binary = Base64.decode64(@binary)
              elsif @binary.encoding == Encoding::UTF_8
                @binary = @binary.unpack('U*').pack('c*')
              end
              Nyoibo.run_callback(:after, ws.request["path"], @json, @binary)
              @binary = @json = nil
              ws.send("OK Bye")
            when CMD_JSON
              msg.gsub!(CMD_JSON, '')
              @json = JSON.parse(msg)
              @json['size'] = @json['size'].to_i
              if Nyoibo.run_callback(:before, ws.request["path"], @json, @binary) == false
                ws.send("ABORT")
                ws.close_websocket
              else
                ws.send("NEXT")
              end
            else
              if msg =~ TYPE_BASE64
                msg.gsub!(TYPE_BASE64, '')
                @binary_type = 'base64'
              end

              if msg.length > 0
                @binary << msg
                ws.send("NEXT")
              else
                ws.send("EMPTY")
              end
            end
          }
        end
      }
      if ENV["NYOIBO_ENV"] == "test"
        daemon.call
      else
        @pid = Process.fork &daemon
        at_exit do
          Process.kill(:KILL, Nyoibo.pid) if Nyoibo.pid
        end
      end
    end
  end
end
