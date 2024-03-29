require 'rack'
require 'rackup'

module Yarrow
  ##
  # Little web server for browsing local files.
  class Server
    attr_reader :config

    def self.default
      new(Yarrow::Configuration.load_defaults)
    end

    def initialize(instance_config)
      if instance_config.server.nil?
        raise ConfigurationError.missing_section(:server)
      end

      @config = instance_config
    end

    ##
    # Rack Middleware for detecting and serving an 'index.html' file
    # instead of a directory index.
    #
    # TODO: Fix bug where a directory /index.html/ causes this to crash
    # TODO: Add configurable mapping and media types for README files as an alternative
    class DirectoryIndex
      def initialize(app, options={})
        @app = app
        @root = options[:root]
        @index_file = options[:index]
      end

      def call(env)
        index_path = File.join(@root, Rack::Request.new(env).path.split('/'), @index_file)
        if File.exist?(index_path)
          return [200, {"Content-Type" => "text/html"}, [File.read(index_path)]]
        else
          @app.call(env)
        end
      end
    end

    # Rack Middleware for rewriting extensionless URLs
    #
    # See surge.sh rewrite rules, that seems like a good starting point for
    # generic behaviour that can be put in place without needing large amounts
    # of config each time.
    class ResourceRewriter
      def initialize(app)
        # No options enabled
        @app = app
      end

      def should_try_rewrite(request_path)
        !request_path.end_with?(".html") || !request_path.end_with?("/")
      end

      def call(env)
        # TODO: document and disambiguate usage of Rack::Request vs env PATH_INFO
        request_path = env["PATH_INFO"]

        try_response = @app.call(env)

        # TODO: reproduces default Netlify behaviour—should be a 301 instead?
        if try_response[0] == 404 and should_try_rewrite(request_path)
          try_response = @app.call(env.merge!({
            "PATH_INFO" => "#{request_path}.html"
          }))
        end

        try_response
      end
    end

    ##
    # Builds a Rack application to serve files in the output directory.
    #
    # If no output directory is specified, defaults to the current working
    # directory.
    #
    # `auto_index` and `live_reload` middleware needs to run in the specific order
    # which is hardcoded here.
    #
    # @return [Yarrow::Server::StaticFiles]
    def app
      app = Rack::Builder.new

      middleware_stack.each do |middleware|
        app.use(middleware)
      end

      app.use(ResourceRewriter)
      app.use(DirectoryIndex, root: docroot, index: default_index)

      app_args = [docroot, {}].tap { |args| args.push(default_type) if default_type }

      static_app = Rack::Files.new(*app_args)

      if live_reload?
        require 'rack-livereload'
        app.use(Rack::LiveReload, no_swf: true)
      end

      if auto_index?
        app.run(Rack::Directory.new(docroot, static_app))
      else
        app.run(static_app)
      end

      app
    end

    ##
    # Starts the server.
    #
    # Listens on `localhost:4000` unless `server.host` and `server.port` are
    # provided in the config.
    #
    def run
      if live_reload?
        reactor = Livereload::Reactor.new
        reactor.start
      end

      handler = Rackup::Handler.get(run_options[:server])

      trap(:INT) do
        handler.shutdown if handler.respond_to?(:shutdown)
        reactor.stop if live_reload?
      end

      handler.run(app, **run_options)
    end

    private

    # Host directory of the mounted web server.
    #
    # Fallback to `config.output_dir`.
    #
    # @return [String]
    def docroot
      config.output_dir
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
    # @return [TrueClass, FalseClass]
    def live_reload?
      if config.server.live_reload then true else false; end
    end

    ##
    # @return [String]
    def default_type
      config.server.default_type
    end

    ##
    # @return [Array<Class>]
    def middleware_stack
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
        :debug => false,
      }
    end
  end
end
