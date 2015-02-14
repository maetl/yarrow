require 'rack'

module Yarrow
  ##
  # Little server for viewing the generated output as a local website.
  class Server

    def self.app
      Rack::Builder.new do
        run Rack::Directory.new(Dir.pwd)
      end
    end

    def self.run
      Rack::Handler.default.run(self.app, :port => 8888)
    end

  end
end
