require "spec_helper"

describe "" do
  xit "collects manifest from source" do
    config = load_config_fixture("essays", { pages: { match_path: "."}})
    generator = Yarrow::Generator.new(config)

    generator.process do |manifest|
      expect(manifest).to be_a(Yarrow::Web::Manifest)
      expect(manifest).to collect_documents_with(:type, [:page, :pages])
      expect(manifest).to collect_documents_with(:name, ["children", "one", "two"])
      expect(manifest).to collect_documents_with(:url, ["/", "/one", "/two"])
      expect(manifest)
    end
  end
end
