require 'rack'

module Yarrow
  ##
  # Little server for viewing the generated output as a local website.
  class Server

    def self.run
      local_server = Rack::Builder.new do
        run Rack::Directory.new(Dir.pwd)
      end

      Rack::Handler.default.run(local_server, :port => 8080)
    end

  end
end
