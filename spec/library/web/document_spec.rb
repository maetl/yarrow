describe Yarrow::Web::Document do
  describe "sources/doctest" do
    let :graph do
      source = Yarrow::Content::Source.collect(fixture_path(self.class.description))
      policy = Yarrow::Content::Policy.from_spec(:content_pages)
      traversal = Yarrow::Content::Expansion::Traversal.new(source, policy)
      traversal.expand
      source
    end

    it "builds simple document from graph" do
      resources = graph.nodes(:resource)
      document = Yarrow::Web::Document.new(resources.first, Yarrow::Web::Manifest.new)

      expect(document.resource).to be_a(ContentPage)
      expect(document.url.to_s).to eq("/one/two/three")
    end
  end
end