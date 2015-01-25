require 'pathname'
require 'fileutils'
require 'sprockets'

module Yarrow
  module Assets
    ##
    # A framework for processing and compressing static assets using Sprockets.
    class Pipeline

      include Loggable

      attr_reader :input_dir, :output_dir, :append_paths, :bundles, :assets

      ##
      # @param config [Yarrow::Configuration]
      def initialize(config)
        raise Yarrow::ConfigurationError if config.assets.nil?

        @input_dir = config.assets.input_dir || default_input_dir

        if config.assets.output_dir
          @output_dir = config.assets.output_dir
        else
          @output_dir = config.output_dir || default_output_dir
        end

        @append_paths = []

        case config.assets.append_paths
        when Array
          @append_paths = config.assets.append_paths
        when '*'
          @append_paths = Dir[@input_dir + '/*'].select do |path|
            File.directory?(path)
          end.map do |path|
            File.basename(path)
          end
        when String
          @append_paths << config.assets.append_paths
        end
      end

      # Compiles an asset manifest and processed output files from the given input bundles.
      # Also generates a manifest linking each output bundle to its given input name.
      # @param bundles [Array<String>]
      def compile(bundles = [])
        bundles.each do |bundle|          
          if bundle.include? '*'
            Dir["#{@input_dir}/#{bundle}"].each do |asset|
              logger.info "Compiling: #{asset}"
              manifest.compile(File.basename(asset))
            end
          else
            logger.info "Compiling: #{bundle}"
            manifest.compile(bundle)
          end
        end
      end

      # Copy the given files to the output path without processing or renaming.
      # @param bundle [Array<String>]
      def copy(bundles = [])
        bundles.each do |bundle|
          FileUtils.cp_r "#{@input_dir}/#{bundle}", "#{@output_dir}/#{bundle}"
        end
      end

      ##
      # Purges redundant compiled assets from the output path.
      #
      # @example Purge all assets except those created in the last 10 minutes
      #   pipeline.purge(0, )
      #
      # @param keep [Integer] Number of previous revisions to keep. Defaults to 2.
      # @param age [Integer] Purge all assets older than this date. Defaults to 1 hour.
      def purge(keep = 2, age = 3600)
        # TODO: upgrade to Sprockets 3.0 to support the age arg
        manifest.clean(keep)
      end

      # Access instance of the Sprockets environment.
      # TODO: make this private to avoid forcing a dependency on Sprockets
      def environment
        @environment ||= create_environment
      end

      private

      def default_input_dir
        "#{Dir.pwd}/assets"
      end

      def default_output_dir
        "#{Dir.pwd}/public/assets"
      end

      def manifest_file_path
        "#{@output_dir}/manifest.json"
      end

      def manifest
        Sprockets::Manifest.new(environment, manifest_file_path)
      end

      def create_environment
        environment = Sprockets::Environment.new(@input_dir)
        
        @append_paths.each do |path|
          environment.append_path path
        end

        environment
      end

    end

  end
end