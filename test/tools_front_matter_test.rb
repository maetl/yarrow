gem "minitest"
require "minitest/autorun"
require "stringio"
require "yarrow"

class ToolsYfmTest < Minitest::Test
  
  include Yarrow::Tools::FrontMatter

  def test_read_split_content
    content, meta = read_split_content(File.dirname(__FILE__) + "/fixtures/tools/front_matter/page.yfm")
    
    assert_equal "<p>Split page content.</p>", content
    assert_equal "page", meta['layout']
    assert_equal "YAML Front Matter", meta['title']
  end

  def test_extract_split_content
    text = File.read(File.dirname(__FILE__) + "/fixtures/tools/front_matter/page.yfm")

    content, meta = extract_split_content(text)
    
    assert_equal "<p>Split page content.</p>", content
    assert_equal "page", meta['layout']
    assert_equal "YAML Front Matter", meta['title']
  end
  
end
