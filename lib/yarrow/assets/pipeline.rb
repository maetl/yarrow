require 'pathname'
require 'fileutils'
require 'sprockets'

module Yarrow
  module Assets
    class Pipeline

      attr_reader :input_dir, :output_dir, :bundles, :assets

      def initialize(options)
        raise 'Missing asset configuration' unless options[:assets]

        @input_dir = options[:assets][:input_dir] || default_input_dir
        @output_dir = options[:assets][:input_dir] || default_output_dir

        case options[:assets][:append_paths]
        when Array
          @append_paths = options[:assets][:append_paths]
        when '*'
          @append_paths = Dir[@input_dir + '/*'].select do |path|
            File.directory?(path)
          end.map do |path|
            File.basename(path)
          end
        else
          @append_paths = []
        end
      end

      def compile(assets = [])
        manifest = Sprockets::Manifest.new(environment, manifest_file_path)
        assets.each do |asset|
          manifest.compile(asset)
        end
      end

      def environment
        @environment ||= create_environment
      end

      private

      def default_input_dir
        "#{Dir.pwd}/assets"
      end

      def default_output_dir
        "#{Dir.pwd}/web/ui"
      end

      def manifest_file_path
        "#{@output_dir}/manifest.json"
      end

      def create_environment
        environment = Sprockets::Environment.new(@input_dir)
        
        @append_paths.each do |path|
          environment.append_path path
        end

        # configure css compressor
        environment.css_compressor = :scss

        environment
      end

    end

  end
end