require 'rack'

module Yarrow
  ##
  # Little web server for browsing local files.
  class Server
    include Configurable

    def initialize
      if config.server.nil?
        config.server = default_server_config
      end
    end

    ##
    # Rack Middleware for detecting and serving an 'index.html' file
    # instead of a directory index.
    #
    # TODO: Add configurable mapping and media types for README files as an alternative
    class DirectoryIndex
      def initialize(app, options={})
        @app = app
        @root = options[:root]
        @index_file = options[:index]
      end

      def call(env)
        index_path =  ::File.join(@root, Rack::Request.new(env).path.split('/'), @index_file)
        if ::File.exists?(index_path)
          return [200, {"Content-Type" => "text/html"}, [::File.read(index_path)]]
        else
          @app.call(env)
        end
      end
    end

    ##
    # Builds a Rack application to serve files in the output directory.
    #
    # If no output directory is specified, defaults to the current working
    # directory.
    #
    # @return [Yarrow::Server::StaticFiles]
    def app
      root = docroot

      Rack::Builder.new do
        use Rack::ShowExceptions
        use Rack::CommonLogger
        use Rack::ContentLength
        use DirectoryIndex, root: root, index: 'index.html'
        run Rack::Directory.new(root)
      end
    end

    ##
    # Starts the server.
    #
    # Listens on `localhost:8888` unless `server.host` and `server.port` are
    # provided in the config.
    #
    def run
      server = Rack::Handler.get(rack_options[:server])
      server.run(app, rack_options)
    end

    private

    ##
    # @return [String]
    def docroot
      config.output_dir || Dir.pwd
    end

    ##
    # @return [Hash]
    def default_server_config
      {
        port: 8888,
        host: 'localhost',
        handler: :thin
      }
    end

    ##
    # Stub to fill in default Rack options that will eventually be
    # provided by config.
    #
    # TODO: remove this and use config.merge to build a single access point
    def rack_options
      rack_options = {
        :Port => config.server.port,
        :Host => config.server.port,
        :server => config.server.handler,
        :daemonize => false,
        :quiet => false,
        :warn => true,
        :debug => true,
      }
    end
  end
end
