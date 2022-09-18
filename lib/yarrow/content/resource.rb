module Yarrow
  module Content
    class Resource < Schema::Entity
      attribute :id, :string
      attribute :name, :string
      attribute :title, :string
      attribute :url, :string
      attribute :content, :string

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
