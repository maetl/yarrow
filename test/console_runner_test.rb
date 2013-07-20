gem "minitest"
require "minitest/autorun"
require "stringio"
require "yarrow"

  
class ConsoleRunnerTest < Minitest::Test  
  
  SUCCESS = 0
  FAILURE = 1
  
  def test_version_message_short
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-v'], output_buffer
    assert_equal SUCCESS, app.run_application
    assert_equal "Yarrow 0.1.0\n", output_buffer.string
  end
  
  def test_version_message_long
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--version'], output_buffer
    assert_equal SUCCESS, app.run_application
    assert_equal "Yarrow 0.1.0\n", output_buffer.string
  end

  def test_help_message_short
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-h'], output_buffer
    assert_equal SUCCESS, app.run_application
    assert_includes output_buffer.string, "Yarrow 0.1.0\n"
    assert_includes output_buffer.string, "Path to the generated documentation"
  end
  
  def test_help_message_long
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--help'], output_buffer
    assert_equal SUCCESS, app.run_application
    assert_includes output_buffer.string, "Yarrow 0.1.0\n"
    assert_includes output_buffer.string, "Path to the generated documentation"
  end
  
end