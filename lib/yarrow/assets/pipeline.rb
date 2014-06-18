require "pathname"
require "fileutils"
require "sprockets"

module Yarrow
  module Assets
    class Pipeline

      attr_reader :input_dir, :output_dir, :bundles, :assets

      # TODO: handle configuration
      def initialize(options = {})
        @input_dir = Dir.pwd + "/assets"
        @output_dir = Dir.pwd + "/web/ui"

        raise "#{@input_dir} is not a directory" unless File.directory? @input_dir
      end

      def compile(assets=[])
        manifest =Sprockets::Manifest.new(environment, manifest_file_path)
        assets.each do |asset|
          manifest.compile(asset)
        end
      end

      def environment
        @environment ||= create_environment
      end

      private

      def manifest_file_path
        "#{@output_dir}/manifest.json"
      end

      def create_environment
        environment = Sprockets::Environment.new(@input_dir)
        # configure javascript
        environment.append_path 'js'

        # configure stylesheets
        environment.append_path 'css'
        environment.css_compressor = :scss

        environment
      end

    end

  end
end
