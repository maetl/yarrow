gem "minitest"
require "minitest/autorun"
require "stringio"
require "yarrow"

  
class ConsoleRunnerTest < Minitest::Test  
  
  SUCCESS = 0
  FAILURE = 1
  
  def test_version_message
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-v'], output_buffer
    assert_equal SUCCESS, app.run_application
    assert_equal "Yarrow 0.1.0\n", output_buffer.string
  end
  
end