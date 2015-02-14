require 'rack'

module Yarrow
  ##
  # Little web server for browsing local files.
  class Server
    include Configurable

    def initialize
      unless config.server
        config.server = default_server_config
      end
    end

    ##
    # Tries to match the request path against a list of file extensions
    # and delegates requests to Rack::Static middleware.
    #
    # @example
    #   use Yarrow::Server::StaticFiles,
    #     root: 'build',
    #     urls: %[/],
    #     try: ['.html', 'index.html', '/index.html']
    #
    class StaticFiles

      def initialize(app, options={})
        @app = app
        @try = ['', *options[:try]]
        @static = ::Rack::Static.new(lambda { |_| [404, {}, []] }, options)
      end

      def call(env)
        orig_path = env['PATH_INFO']
        found = nil
        @try.each do |path|
          resp = @static.call(env.merge!({'PATH_INFO' => orig_path + path}))
          break if !(403..405).include?(resp[0]) && found = resp
        end
        found or @app.call(env.merge!('PATH_INFO' => orig_path))
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
      options = static_files_options
      root = docroot
      Rack::Builder.new do
        use Rack::ShowExceptions
        use Rack::CommonLogger
        use Rack::ContentLength
        use StaticFiles, options
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
    # @return [Array]
    def static_files_options
      {
        root: docroot,
        urls: %[/],
        try: ['.html', 'index.html', '/index.html']
      }
    end

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
