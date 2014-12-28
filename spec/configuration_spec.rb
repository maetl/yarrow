require "spec_helper"

describe Yarrow::Configuration do
  
  describe "#register" do

    it "registers a global instance from local fixture" do
      Yarrow::Configuration.register(File.dirname(__FILE__) + "/fixtures/test.yml")
      config = Yarrow::Configuration.instance

      expect(config.meta.title).to eq "Test Project"
    end

  end

  describe "#load" do

    it "loads from local fixture" do
      config = Yarrow::Configuration.load(File.dirname(__FILE__) + "/fixtures/test.yml")

      expect(config.meta.title).to eq "Test Project"
    end

  end

  describe "#new" do

    it "provides path traversal on nested properties" do
      config = Yarrow::Configuration.new({"meta" => { "title" => "Test Project" }})

      expect(config.meta.title).to eq "Test Project"
    end

    it "provides key lookups on nested properties" do
      config = Yarrow::Configuration.new({"meta" => { "title" => "Test Project" }})

      expect(config[:meta][:title]).to eq "Test Project"
    end

  end

  describe "#deep_merge!" do

    it "merges properties with last-in precedence" do
      config = Yarrow::Configuration.new({"one" => "one"})
      config.deep_merge! Yarrow::Configuration.new({"one" => 1, "two" => 2})

      expect(config.one).to eq 1
      expect(config.two).to eq 2    
    end

  end

end
