require "spec_helper"

module Sources
  module EssaysSpec
    class Essays
      attr_accessor :name, :title
  
      def initialize(meta)
        @name = meta[:name]
        @title = meta[:title]
      end
  
      def merge(other)
        self
      end
    end
  
    class Essay
      attr_accessor :name, :title, :body
  
      def initialize(meta)
        @name = meta[:name]
        @title = meta[:title]
        @body = meta[:body]
      end
    end
  end
end

describe "fixtures/sources/essays" do
  xit ":directory_merge root policy" do
    config = load_example_fixture("essays", "Sources::EssaysSpec", {
      essays: {
        expansion: :directory_merge,
        source_path: "."
      }
    })
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:essays, :essay])
      expect(manifest).to collect_documents_with(:name, ["essays", "essay-1", "essay-2"])
      expect(manifest).to collect_documents_with(:url, ["/", "/essay-1", "/essay-2"])
    end
  end

  xit ":directory_merge nested policy" do
    config = load_example_fixture("", "Sources::EssaysSpec", {
      essays: {
        expansion: :directory_merge,
        source_path: "essays"
      }
    })
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:essays, :essay])
      #expect(manifest).to collect_documents_with(:name, ["essays", "essay-1", "essay-2"])
      #expect(manifest).to collect_documents_with(:url, ["/essays/", "/essays/essay-1", "/essays/essay-2"])
      expect(manifest).to collect_documents_with(:name, ["essays", "essay-1", "essay-2"])
      expect(manifest).to collect_documents_with(:url, ["/", "/essay-1", "/essay-2"])
    end
  end
end
