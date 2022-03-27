require "spec_helper"

describe Yarrow::Configuration do
  describe "#load" do

    it "loads from local fixture" do
      config = Yarrow::Configuration.load(File.dirname(__FILE__) + "/fixtures/test.yml")

      expect(config.meta.title).to eq "Doctest"
    end

    it "loads from defaults" do
      config = Yarrow::Configuration.load_defaults

      expect(config.meta.author).to eq "Default Name"
    end
  end

  describe "#deep_merge!" do

    xit "merges properties with last-in precedence" do
      config = Yarrow::Configuration.new({"one" => "one"})
      config.deep_merge! Yarrow::Configuration.new({"one" => 1, "two" => 2})

      expect(config.one).to eq 1
      expect(config.two).to eq 2
    end

  end
end
