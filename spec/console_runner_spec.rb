require "spec_helper"
require "stringio"

describe Yarrow::ConsoleRunner do

  SUCCESS = 0
  FAILURE = 1

  it "test_version_message_short" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-v'], output_buffer

    expect(app.run_application).to eq SUCCESS
    expect(output_buffer.string).to include(Yarrow::VERSION + "\n")
  end

  it "test_version_message_long" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--version'], output_buffer
    
    expect(app.run_application).to eq SUCCESS
    expect(output_buffer.string).to include(Yarrow::VERSION + "\n")
  end

  it "test_help_message_short" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-h'], output_buffer
    
    expect(app.run_application).to eq SUCCESS
    expect(output_buffer.string).to include(Yarrow::VERSION + "\n")
    expect(output_buffer.string).to include("Path to the generated documentation")
  end
  
  it "test_help_message_long" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--help'], output_buffer
    
    expect(app.run_application).to eq SUCCESS
    expect(output_buffer.string).to include(Yarrow::VERSION + "\n")
    expect(output_buffer.string).to include("Path to the generated documentation")
  end

  it "test_invalid_short_option_message" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '-j'], output_buffer

    expect(app.run_application).to eq FAILURE
    expect(output_buffer.string).to include("Unrecognized option: -j")
  end
  
  it "test_invalid_long_option_message" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--invalid'], output_buffer
    
    expect(app.run_application).to eq FAILURE
    expect(output_buffer.string).to include("Unrecognized option: --invalid")
  end

  it "test_invalid_long_option_message" do
    output_buffer = StringIO.new
    app = Yarrow::ConsoleRunner.new ['yarrow', '--invalid'], output_buffer
    
    expect(app.run_application).to eq FAILURE
    expect(output_buffer.string).to include("Unrecognized option: --invalid")
  end
  
  it "test_config_loads_if_file_exists" do
    output_buffer = StringIO.new
    test_config = File.dirname(__FILE__) + '/fixtures/test.yml'
    
    app = Yarrow::ConsoleRunner.new ['yarrow', '--config=' + test_config], output_buffer
    
    expect(app.run_application).to eq SUCCESS
    expect(app.config.meta.title).to eq "Test Project"
  end
  
  it "test_config_fails_if_file_is_missing" do
    output_buffer = StringIO.new
    test_config = File.dirname(__FILE__) + '/fixtures/missing.yml'
    
    app = Yarrow::ConsoleRunner.new ['yarrow', '--config=' + test_config], output_buffer
    
    expect(app.run_application).to eq FAILURE
    expect(output_buffer.string).to include("No such file or directory")
  end

end
