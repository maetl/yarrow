require "spec_helper"

describe Yarrow::Configuration do
  
  it "test_load_from_file" do
    config = Yarrow::Configuration.load(File.dirname(__FILE__) + "/fixtures/test.yml")

    expect(config.meta.title).to eq "Test Project"
  end

  it "test_nested_property_access" do
    config = Yarrow::Configuration.new({"meta" => { "title" => "Test Project" }})

    expect(config.meta.title).to eq "Test Project"
  end

  it "test_deep_merge_precedence" do
    config = Yarrow::Configuration.new({"one" => "one"})
    config.deep_merge! Yarrow::Configuration.new({"one" => 1, "two" => 2})

    expect(config.one).to eq 1
    expect(config.two).to eq 2    
  end

end
