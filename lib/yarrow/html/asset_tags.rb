module Yarrow
  module HTML
    module AssetTags
      
      # TODO: make sprockets manifest optional/pluggable
      def manifest
        Yarrow::Assets::Manifest.new(config || {})
      end

      def all_script_tags
        out = []
        manifest.digest_paths.each do |asset|
          out << script_tag(:asset => asset)
        end
        out.join["\n"]
      end

      def script_tag(options)
        if options.has_key? :asset and manifest.exists?(options[:asset])
          src_path = manifest.digest_path(options[:asset])
        else
          src_path = options[:src]
        end

        "<script src=\"#{src_path}\"></script>"
      end

      def link_tag(options)
        if options.has_key? :asset and manifest.exists?(options[:asset])
          href_path = manifest.digest_path(options[:asset])
        else
          href_path = options[:href]
        end

        "<link href=\"#{href_path}\" rel=\"stylesheet\" type=\"text/css\">"
      end

    end
  end
end
