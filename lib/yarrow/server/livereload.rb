require 'eventmachine'
require 'em-websocket'
require 'json'

module Yarrow
  class Server
    module Livereload
      class Reactor
        def initialize
          @sockets = []
        end

        def start
          @thread = Thread.new do
            run_loop
          end
        end

        def shutdown
          puts 'Shutting down Livereload'
          @thread.kill
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
            puts 'Starting Livereload reactor on port: 35729'
            EventMachine::WebSocket.start(:host => 'localhost', :port => 35729) do |socket|
              socket.onopen do
                socket.send "!!ver:1.6"
                @sockets << socket
                puts 'Livereload connected'
              end

              socket.onmessage do |message|
                puts "Receiving message: #{message}"
              end

              socket.onclose do
                @sockets.delete(socket)
                puts 'Livereload disconnected'
              end
            end
          end
        end
      end
    end
  end
end
