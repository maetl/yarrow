module Yarrow
  module Content
    class Resource < Schema::Entity
      attribute :id, String
      attribute :name, String
      attribute :title, String
      attribute :url, String
      attribute :content, String

      def self.from_frontmatter_url(data, url_field)
        new({
          id: data[:id],
          name: data[:name],
          title: data[:title],
          content: data[:content],
          url: data[url_field]
        })
      end

      def self.from_template_url(data, template, &block)

      end

      def self.from_source_path(data, &block)

      end
    end
  end
end
