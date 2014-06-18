require "spec_helper"

describe Yarrow::Generator do

  it "test_ensure_dir_if_not_existing" do
    generator = Yarrow::Generator.new "new_path_test", {}
    
    expect(File.directory?("new_path_test")).to eq true
    
    Dir.rmdir "new_path_test"
  end

end
