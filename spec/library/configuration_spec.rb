require "spec_helper"

describe Yarrow::Configuration do
  describe "#load" do
    it "loads from local fixture" do
      config = Yarrow::Configuration.load(fixture_path("test.yml"))

      expect(config.meta.title).to eq "Doctest"
    end
  end

  describe "#load_defaults" do
    it "loads from defaults" do
      config = Yarrow::Configuration.load_defaults

      expect(config.meta.author).to eq "Default Name"
    end
  end

  describe "#merge" do
    it "merges properties with last-in precedence" do
      defaults = Yarrow::Configuration.load_defaults
      config = defaults.merge(Yarrow::Configuration.load(fixture_path("test.yml")))

      expect(config.meta.title).to eq "Doctest"
    end
  end
end
