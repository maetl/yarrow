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

  def test_invalid_short_option_message
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-j'], output_buffer
    assert_equal FAILURE, app.run_application
    assert_includes output_buffer.string, "Unrecognized option: -j"
  end
  
  def test_invalid_long_option_message
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--invalid'], output_buffer
    assert_equal FAILURE, app.run_application
    assert_includes output_buffer.string, "Unrecognized option: --invalid"
  end

  def test_invalid_long_option_message
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--invalid'], output_buffer
    assert_equal FAILURE, app.run_application
    assert_includes output_buffer.string, "Unrecognized option: --invalid"
  end
	
	def test_config_loads_if_file_exists
	  output_buffer = StringIO.new
	  test_config = File.dirname(__FILE__) + '/fixtures/test.yml'
	  
    app = Yarrow::ConsoleRunner.new ['yarrow', '--config=' + test_config], output_buffer
    assert_equal SUCCESS, app.run_application
    assert_equal app.config.meta.title, "Test Project"
	end
	
	def test_config_fails_if_file_is_missing
	  output_buffer = StringIO.new
	  test_config = File.dirname(__FILE__) + '/fixtures/missing.yml'
	  
    app = Yarrow::ConsoleRunner.new ['yarrow', '--config=' + test_config], output_buffer
    assert_equal FAILURE, app.run_application
    assert_includes output_buffer.string, "No such file or directory"
	end
  
end