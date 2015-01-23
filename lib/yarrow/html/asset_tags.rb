module Yarrow
  module HTML
    module AssetTags     
      include Yarrow::Configurable

      # TODO: make sprockets manifest optional/pluggable
      def manifest
        Yarrow::Assets::Manifest.new(config || {})
      end

      def script_tags
        manifest.js_logical_paths.map { |asset_path| script_tag(asset: asset_path) }.join("\n")
      end

      # TODO: support asset path option?
      def script_tag(options)
        if options.has_key? :asset and manifest.exists? options[:asset]
          script_path = manifest.digest_path(options[:asset])
          assets_path = config.assets_path || ''
          src_path = [assets_path, script_path].join('/')
        else
          src_path = options[:src]
        end

        "<script src=\"#{src_path}\"></script>"
      end

      # TODO: support asset path option?
      def link_tag(options)
        if options.has_key? :asset and manifest.exists? options[:asset]
          stylesheet_path = manifest.digest_path(options[:asset])
          assets_path = config.assets_path || ''
          href_path = [assets_path, stylesheet_path].join('/')      
        else
          href_path = options[:href]
        end

        "<link href=\"#{href_path}\" rel=\"stylesheet\" type=\"text/css\">"
      end

    end
  end
end
