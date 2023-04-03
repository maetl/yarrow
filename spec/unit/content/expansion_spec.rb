describe Yarrow::Content::Expansion do
  describe :pages do
    let(:content) do
      Yarrow::Content::Graph.from_source(load_config_fixture("pages"))
    end

    let(:tree_strategy) do
      Yarrow::Content::Expansion::Tree.new(content.graph)
    end

    it "-->" do
      policy = Yarrow::Content::Policy.from_spec(:pages, {}, "TestContentGraph")
      tree_strategy.expand(policy)

      File.write("_pages.dot", content.graph.to_dot)

      expect(content.graph.nodes(type: :page).count).to eq(3)
    end
  end
end
