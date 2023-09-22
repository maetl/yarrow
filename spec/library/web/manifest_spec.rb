describe Yarrow::Web::Manifest do
  describe "sources/doctest" do
    let :graph do
      source = Yarrow::Content::Source.collect(fixture_path(self.class.description))
      policy = Yarrow::Content::Policy.from_spec(:content_pages)
      traversal = Yarrow::Content::Expansion::Traversal.new(source, policy)
      traversal.expand
      source
    end

    it "builds manifest from resource" do
      resources = graph.nodes(:resource)
      manifest = Yarrow::Web::NewManifest.new
      manifest.add_resource(resources.first)

      expect(manifest.documents.first.resource).to be_a(ContentPage)
    end
  end
end