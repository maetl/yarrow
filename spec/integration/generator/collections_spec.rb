require "spec_helper"

describe "collections" do
  it "collects manifest from source" do
    config = load_config_fixture("collections")
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:url, [
        "/", "/articles/", "/articles/title", "/photos/", "/photos/melonslapcat",
        "/posts/", "/posts/one", "/posts/two",  "/posts/three"
      ])
    end
  end
end
