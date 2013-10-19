gem "minitest"
require "minitest/autorun"
require "stringio"
require "yarrow"

class ConfigurationTest < Minitest::Test
  
  def test_load_from_file
    config = Yarrow::Configuration.load(File.dirname(__FILE__) + "/fixtures/test.yml")
    
    assert_equal "Test Project", config.meta.title
  end
  
  def test_nested_property_access
    properties = Yarrow::Configuration.new({"meta" => { "title" => "Test Project" }})
    
    assert_equal "Test Project", properties.meta.title
  end
  
  def test_deep_merge_precedence
    config = Yarrow::Configuration.new({"one" => "one"})
    config.deep_merge! Yarrow::Configuration.new({"one" => 1, "two" => 2})
    
    assert_equal 1, config.one
    assert_equal 2, config.two
  end
  
end