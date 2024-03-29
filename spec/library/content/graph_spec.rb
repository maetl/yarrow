require "spec_helper"

describe Yarrow::Content::Graph do
  describe "expansion" do
    let(:content) do
      Yarrow::Content::Graph.from_source(load_config_fixture("pages"))
    end

    it "expands :pages by default" do
      model = Yarrow::Content::Model.new(
        Yarrow::Config::Content.new(
          module: "TestContentGraph",
          source_map: {
            pages: :page
          }
        )
      )
      model.expand(content.graph)

      expect(
        Set.new(content.graph.nodes.map { |n| n.label })
      ).to eq(Set.new([:root, :collection, :resource, :file, :directory]))
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
