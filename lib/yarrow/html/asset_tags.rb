module Yarrow
  module HTML
    module AssetTags
      include Yarrow::Configurable

      # TODO: make sprockets manifest optional/pluggable
      def manifest
        Yarrow::Assets::Manifest.new(config)
      end

      ##
      # Computes the base URL path to assets in the public web directory.
      def base_url_path
        if config.assets.nil? || config.output_dir.nil?
          raise Yarrow::ConfigurationError
        end

        # TODO: prepend configurable CDN URL for host path
        # TODO: dev/production mode switch

        config.assets.output_dir.gsub(config.output_dir, '')
      end

      def script_tags
        manifest.js_logical_paths.map { |path| script_tag(asset: path) }.join("\n")
      end

      def script_tag(options)
        src_path = if asset_in_manifest?(options)
          digest_path(options[:asset])
        else
          options[:src]
        end

        "<script src=\"#{src_path}\"></script>"
      end

      def link_tag(options)
        href_path = if asset_in_manifest?(options)
           digest_path(options[:asset])
        else
          options[:href]
        end

        "<link href=\"#{href_path}\" rel=\"stylesheet\" type=\"text/css\">"
      end

      private

      def asset_in_manifest?(options)
        options.has_key?(:asset) and manifest.exists?(options[:asset])
      end

      def digest_path(path)
        "#{base_url_path}/#{manifest.digest_path(path)}"
      end
    end
  end
end
