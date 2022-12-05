require "spec_helper"

describe "doctest" do
  it "collects manifest from source" do
    config = load_config_fixture("pages")
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      #p manifest

      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:page, :pages])
      expect(manifest).to collect_documents_with(:name, ["about", "pages", "children", "one", "two"])
      expect(manifest).to collect_documents_with(:url, ["/", "/about", "/children/", "/children/one", "/children/two"])
      expect(manifest)
    end
  end
end
