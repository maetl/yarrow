require "spec_helper"

describe Yarrow::Content::Graph do
  describe "expansion" do
    let(:content) do
      Yarrow::Content::Graph.from_source(load_config_fixture("pages"))
    end

    it "expands :pages by default" do
      expander = Yarrow::Content::Expansion.new(Yarrow::Content::Model.new)
      expander.expand(content.graph)

      expect(
        Set.new(content.graph.nodes.map { |n| n.label })
      ).to eq(Set.new([:root, :collection, :item, :file, :directory]))
    end
  end

  describe "pages" do
    let(:content) do
      Yarrow::Content::Graph.from_source(load_config_fixture("pages"))
    end

    it "reads a source graph from files" do
      expect(content.files.count).to eq(4)
      expect(content.directories.count).to eq(2)

      expect(
        Set.new(content.files.map { |f| f.props[:name] })
      ).to eq(Set.new(['about.htm', 'index.htm', 'one.htm', 'two.htm']))
    end

    it "expands source files into collections" do
      class Page
        def initialize(props)
          @props = props
        end
      end

      content.expand_pages
    end
  end

  describe "collections" do
    it "reads a source graph from files" do
      config = load_config_fixture("collections")
      content = Yarrow::Content::Graph.from_source(config)

      expect(content.files.count).to eq(5)
      expect(content.directories.count).to eq(4)

      expect(
        Set.new(content.directories.map { |f| f.props[:name] })
      ).to eq(Set.new(["collections", "articles", "photos", "posts"]))
    end
  end
end
