describe Yarrow::Content::Expansion do
  # TODO: rename to Content::Expansion and introduce expansion strategy concept
  describe "doctest fixture" do
    let(:doctest_source) do
      config = load_config_fixture("doctest")
      Yarrow::Content::Graph.from_source(config)
    end

    let(:content_spec) do
      Yarrow::Config::Content.new(
        namespace: "Site",
        model: {
          root: Yarrow::Content::ContentPolicy.new(
            expansion: :tree,
            dir: "*",
            file: "*.md",
            :container => :pages,
            :record => :page
          )
        }
      )
    end

    xit "generates a set of pages from markdown files" do
      # If a list of object types is not provided
      # a default `pages` type is created.
      model = Yarrow::Content::Model.new(content_spec)
      model.expand(doctest_source.graph)

      expect(doctest_source.collections.length).to be(1)
      expect(doctest_source.collections.first.label).to be(:collection)
      expect(doctest_source.collections.first.props[:type]).to be(:pages)
      expect(doctest_source.collections.first.props[:name]).to eq("doctest")

      #p doctest_source.items.first.props

      expect(doctest_source.items.length).to be(3)
      expect(doctest_source.items.first.label).to be(:item)
      expect(doctest_source.items.first.props[:type]).to be(:page)

      expect(
        Set.new(doctest_source.items.map { |i| i.props[:name] })
      ).to eq(Set.new(["page1", "page2", "page3"]))

      # TODO: extract and map content
      # expect(
      #   Set.new(doctest_source.items.map { |i| i.props[:title] })
      # ).to eq(Set.new(["Page 1", "Page 2", "Page 3"]))
    end
  end
end
