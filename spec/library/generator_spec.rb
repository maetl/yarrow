require "spec_helper"

describe Yarrow::Generator do
  it "generates a set of pages from markdown files" do
    config = load_config_fixture("doctest")
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)

      expect(manifest.documents.count).to be(4)

      expect(
        Set.new(manifest.documents.map { |doc| doc.type })
      ).to eq(Set.new([:page, :pages]))

      expect(
        Set.new(manifest.documents.map { |doc| doc.name })
      ).to eq(Set.new(["doctest", "page1", "page2", "page3"]))

      # expect(
      #   Set.new(manifest.documents.map { |doc| doc.url })
      # ).to eq(Set.new(["/pages/", "/pages/page1", "/pages/page2", "/pages/page3"]))

      expect(
        Set.new(manifest.documents.map { |doc| doc.title })
      ).to eq(Set.new(["Doctest", "Page 1", "Page 2", "Page 3"]))
    end
  end
end
