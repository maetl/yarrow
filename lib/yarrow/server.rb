require 'rack'

module Yarrow
  ##
  # Little web server for browsing local files.
  class Server
    include Configurable

    def initialize
      if config.server.nil?
        raise ConfigurationError.new('Missing server entry')
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
        index_path = File.join(@root, Rack::Request.new(env).path.split('/'), @index_file)
        if File.exists?(index_path)
          return [200, {"Content-Type" => "text/html"}, [File.read(index_path)]]
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
      index = default_index
      middleware_stack = middleware_map
      auto_index = auto_index?
      mime_type = default_type

      Rack::Builder.new do
        middleware_stack.each do |middleware|
          use middleware
        end

        use DirectoryIndex, root: root, index: index

        app_args = [root, {}].tap { |args| args.push(mime_type) if mime_type }
        static_app = Rack::File.new(*app_args)

        if auto_index
          run Rack::Directory.new(root, static_app)
        else
          run static_app
        end
      end
    end

    ##
    # Starts the server.
    #
    # Listens on `localhost:8888` unless `server.host` and `server.port` are
    # provided in the config.
    #
    def run
      server = Rack::Handler.get(run_options[:server])
      server.run(app, run_options)
    end

    private

    ##
    # @return [String]
    def docroot
      config.output_dir || Dir.pwd
    end

    ##
    # @return [String]
    def default_index
      config.server.default_index || 'index.html'
    end

    ##
    # @return [TrueClass, FalseClass]
    def auto_index?
      return true if config.server.auto_index.nil?
      config.server.auto_index
    end

    ##
    # @return [String]
    def default_type
      config.server.default_type
    end

    ##
    # @return [Array<Class>]
    def middleware_map
      middleware = config.server.middleware || []
      middleware.map { |class_name| Kernel.const_get(class_name) }
    end

    ##
    # Provides options required by the Rack server on startup.
    #
    # @return [Hash]
    def run_options
      {
        :Port => config.server.port,
        :Host => config.server.host,
        :server => config.server.handler.to_sym,
        :daemonize => false,
        :quiet => false,
        :warn => true,
        :debug => true,
      }
    end
  end
end
