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
        raise Yarrow::ConfigurationError if config.assets.nil?
        raise Yarrow::ConfigurationError if config.output_dir.nil?

        # TODO: prepend configurable CDN URL for host path
        # TODO: dev/production mode switch

        assets_path = config.assets.output_dir
        assets_path.gsub(config.output_dir, '')
      end

      def script_tags
        manifest.js_logical_paths.map { |asset_path| script_tag(asset: asset_path) }.join("\n")
      end

      # TODO: support asset path option?
      def script_tag(options)
        if options.has_key? :asset and manifest.exists? options[:asset]
          script_path = manifest.digest_path(options[:asset])
          src_path = "#{base_url_path}/#{script_path}"
        else
          src_path = options[:src]
        end

        "<script src=\"#{src_path}\"></script>"
      end

      # TODO: support asset path option?
      def link_tag(options)
        if options.has_key? :asset and manifest.exists? options[:asset]
          stylesheet_path = manifest.digest_path(options[:asset])
          href_path = "#{base_url_path}/#{stylesheet_path}"      
        else
          href_path = options[:href]
        end

        "<link href=\"#{href_path}\" rel=\"stylesheet\" type=\"text/css\">"
      end

    end
  end
end
