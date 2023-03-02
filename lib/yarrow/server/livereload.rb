begin
  require 'eventmachine'
rescue
  require 'em/pure_ruby'
end
require 'em-websocket'
require 'json'

module Yarrow
  class Server
    module Livereload
      class Reactor
        include Yarrow::Loggable

        def initialize
          @sockets = []
          @running = false
        end

        def running?
          @running
        end

        def start
          @thread = Thread.new do
            run_loop
          end
          @running = true
        end

        def stop
          logger.info 'Shutting down Livereload'
          @thread.kill
          @running = false
        end

        def refresh_payload(path)
          data = JSON.dump(['refresh', {
            :path           => path,
            :apply_js_live  => false,
            :apply_css_live => false
          }])
        end

        def send_refresh
          @updated_paths.each do |path|
            @sockets.each do |ws|
              ws.send(refresh_payload(path))
            end
          end
        end

        def run_loop
          EventMachine.run do
            logger.info 'Starting Livereload reactor on port: 35729'

            EventMachine::WebSocket.start(:host => 'localhost', :port => 35729) do |socket|
              socket.onopen do
                socket.send "!!ver:1.6"
                @sockets << socket
                logger.info 'Livereload connected'
              end

              socket.onmessage do |message|
                logger.info "Receiving message: #{message}"
              end

              socket.onclose do
                @sockets.delete(socket)
                logger.info 'Livereload disconnected'
              end
            end
          end
        end
      end
    end
  end
end
