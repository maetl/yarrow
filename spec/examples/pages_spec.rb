require "spec_helper"

module Sources
  module PagesSpec
    class Pages
      attr_accessor :name, :title
  
      def initialize(meta)
        @name = meta[:name]
        @title = meta[:title]
      end
  
      def merge(other)
        self
      end
    end
  
    class Page
      attr_accessor :name, :title, :body
  
      def initialize(meta)
        @name = meta[:name]
        @title = meta[:title]
        @body = meta[:body]
      end
    end
  end
end

describe "fixtures/sources/pages" do
  it ":filename_map root policy" do
    config = load_example_fixture("pages", "Sources::PagesSpec", {
      pages: {
        expansion: :filename_map,
        source_path: "."
      }
    })
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:page, :pages])
      expect(manifest).to collect_documents_with(:name, ["index", "about", "children", "one", "two"])
      expect(manifest).to collect_documents_with(:url, ["/", "/about", "/children/", "/children/one", "/children/two"])
      #File.write("pages_root_policy.dot", manifest.graph.to_dot)
    end
  end

  it ":filename_map nested policy" do
    config = load_example_fixture("pages", "Sources::PagesSpec", {
      pages: {
        expansion: :filename_map,
        source_path: "children"
      }
    })
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:page, :pages])
      expect(manifest).to collect_documents_with(:name, ["children", "one", "two"])
      expect(manifest).to collect_documents_with(:url, ["/", "/one", "/two"])
      #File.write("pages_nested_policy.dot", manifest.graph.to_dot)
    end
  end
end
