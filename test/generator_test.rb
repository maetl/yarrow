gem "minitest"
require "minitest/autorun"
require "stringio"
require "yarrow"

class GeneratorTest < Minitest::Test
  
  def test_ensure_dir_if_not_existing
    generator = Yarrow::Generator.new "new_path_test", {}
    
    assert File.directory?("new_path_test")
    
    Dir.rmdir "new_path_test"
  end
  
end