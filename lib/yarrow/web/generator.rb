module Yarrow
  module Web
    class Generator
      attr_reader :config

      def initialize(config)
        @config = config
        # Config is here but we haven’t decided on schema for web publishing fields
        # so hard-code the needed values as part of this prototype
        @default_host = "http://example.com"
      end

      def generate(manifest)
        Parallel.each(manifest.documents) do |document|
          write_document(document)
        end
        #generate_sitemap(manifest)
      end

      def write_document(document)
        template = Template.for_document(document, config)
        write_output_file(document.url, template.render(document))
      end

      def write_output_file(url, content)
        # If the target path is a directory,
        # generate a default index filename.
        if url[url.length-1] == '/'
          url = "#{url}index"
        end

        # Construct full path to file in output dir
        path = @config.output_dir.join(url.delete_prefix("/")).sub_ext('.html')

        # Create directory path if it doesn’t exist
        FileUtils.mkdir_p(path.dirname)

        # Write out the file
        File.open(path.to_s, 'w+:UTF-8') do |file|
          file.puts(content)
        end

        puts "[write] #{path} → #{url}"
      end

      def generate_sitemap(manifest)
        # SitemapGenerator::Sitemap.default_host = @default_host
        # SitemapGenerator::Sitemap.public_path = @public_dir
        # SitemapGenerator::Sitemap.create do
        #   manifest.documents.each do |document|
        #     # Options: :changefreq, :lastmod, :priority, :expires
        #     #add(document.url, lastmod: document.published_at)
        #     add(document.url)
        #   end
        # end
      end
    end
  end
end
