gem "minitest"
require "minitest/autorun"
require "stringio"
require "yarrow"

class ConfigurationTest < Minitest::Test
  
  def test_load_default_settings
    config = Yarrow::Configuration.load(File.dirname(__FILE__) + "/fixtures/test.yml")
    
    assert_equal "Test Project", config.meta.title
  end
  
end