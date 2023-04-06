require "spec_helper"

describe "doctest" do
  it "collects manifest from source" do
    config = load_config_fixture("doctest")
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:page, :pages])
      expect(manifest).to collect_documents_with(:name, ["doctest", "page1", "page2", "page3"])
      expect(manifest).to collect_documents_with(:url, ["/", "/page1", "/page2", "/page3"])
      expect(manifest)
    end
  end
end
