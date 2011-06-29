module Nyoibo
  module Daemon
    attr_reader :pid
    def run
      daemon = lambda{
        EventMachine::WebSocket.start(:host => config.host, :port => config.port) do |ws|
          ws.onopen {
            ws.send "OK Ready"
          }
          ws.onclose {
            EventMachine.stop
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
