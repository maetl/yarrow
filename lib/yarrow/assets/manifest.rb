# TODO: where else is this used?
require 'json'

module Yarrow
  module Assets

    ##
    # Provides access to the bundle of compiled CSS and JS assets.
    #
    class Manifest

      def initialize(config)
        if config[:output_dir] && config[:manifest_path]
          manifest_path = [config[:output_dir], config[:manifest_path]].join('/')
        else
          manifest_path = './manifest.json'
        end

        if File.exists?(manifest_path)
          @manifest_index = JSON.parse(File.read(manifest_path))
        else
          @manifest_index = {
            'assets' => {},
            'files' => {}
          }
        end
      end

      def exists?(logical_path)
      	@manifest_index['assets'].key? logical_path
      end

      def digest_path(logical_path)
      	@manifest_index['assets'][logical_path]
      end

      def file(logical_path)
      	@manifest_index['files'][digest_path(logical_path)]
      end

      def logical_paths
      	@manifest_index['assets'].keys
      end

      def digest_paths
      	@manifest_index['files'].keys
      end

      def files
      	@manifest_index['files'].values
      end

    end
  end
end
