require "spec_helper"

describe Yarrow::Configuration do
  
  describe "#instance" do

    it "provides an empty default" do
      expect(Yarrow::Configuration.instance).to eq Yarrow::Configuration.new
    end

    it "provides an empty default when cleared" do
      Yarrow::Configuration.clear
      expect(Yarrow::Configuration.instance).to eq Yarrow::Configuration.new
    end

  end

  describe "#register" do

    it "registers a global instance from local fixture" do
      Yarrow::Configuration.register(File.dirname(__FILE__) + "/fixtures/test.yml")
      config = Yarrow::Configuration.instance

      expect(config.meta.title).to eq "Test Project"

      Yarrow::Configuration.clear
    end

  end

  describe "#load" do

    it "loads from local fixture" do
      config = Yarrow::Configuration.load(File.dirname(__FILE__) + "/fixtures/test.yml")

      expect(config.meta.title).to eq "Test Project"
    end

  end

  describe "#new" do

    it "provides path traversal on nested string keys" do
      config = Yarrow::Configuration.new({"meta" => { "title" => "Test Project" }})

      expect(config.meta.title).to eq "Test Project"
    end

    it "provides path traversal on nested symbol keys" do
      config = Yarrow::Configuration.new({:meta => { :title => "Test Project" }})

      expect(config.meta.title).to eq "Test Project"
    end

    it "provides hash lookups on nested string keys" do
      config = Yarrow::Configuration.new({"meta" => { "title" => "Test Project" }})

      expect(config[:meta][:title]).to eq "Test Project"
    end

    it "provides hash lookups on nested symbol keys" do
      config = Yarrow::Configuration.new({:meta => { :title => "Test Project" }})

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
