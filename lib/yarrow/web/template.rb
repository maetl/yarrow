module Yarrow
  module Web
    class Template
      def self.for_document(document)
        layout_name = if document.respond_to?(:layout)
          document.layout || document.type
        else
          document.type
        end

        @template_dir = "./spec/fixtures/templates/doctest"
        @template_ext = ".html"

        template_file = "#{layout_name}#{@template_ext}"
        template_path = Pathname.new(@template_dir) + template_file

        new(template_path.read)
      end

      def initialize(source)
        @source = source
      end

      def render(document)
        Mustache.render(@source, document)
      end
    end
  end
end
