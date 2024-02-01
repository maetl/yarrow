require "spec_helper"

describe "Remix" do
  describe "Configuration" do
    it "loads from source file" do
      config_instance = Yarrow::Configuration.load(fixture_path("yarrowdoc.kdl"))

      expect(config_instance.content.directory).to eq("~/Documents/Projects")
      expect(config_instance.content.module).to eq("Project::Model")
      expect(config_instance.content.expansions).to be_a(Array)

      config_instance.content.expansions.at(0).tap do |policy|
        expect(policy).to be_a(Yarrow::Configuration::ExpansionPolicy)
        expect(policy.container).to eq(:pages)
        expect(policy.collection).to eq(:pages)
        expect(policy.entry).to eq(:page)
      end

      config_instance.content.expansions.at(1).tap do |policy|
        expect(policy).to be_a(Yarrow::Configuration::ExpansionPolicy)
        expect(policy.container).to eq(:notebooks)
        expect(policy.collection).to eq(:notebook)
        expect(policy.entry).to eq(:note)
      end

      config_instance.content.expansions.at(2).tap do |policy|
        expect(policy).to be_a(Yarrow::Configuration::ExpansionPolicy)
        expect(policy.container).to eq(:blog)
        expect(policy.collection).to eq(:blog)
        expect(policy.entry).to eq(:post)
      end
    end
  end
end
