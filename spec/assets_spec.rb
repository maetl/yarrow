require "spec_helper"

describe Yarrow::Assets::Pipeline do

  it "initializes with a base asset path" do
    config = {
      :assets => {
        :input_dir => "spec/fixtures/assets"
      }
    }
    pipeline = Yarrow::Assets::Pipeline.new(config)

    expect(pipeline.environment.paths).not_to include("stylesheets")
  end

  it "can append paths to the Sprockets environment" do
    config = {
      :assets => {
        :input_dir => "assets",
        :output_dir => "web/ui",
        :append_paths => ["stylesheets", "javascripts"]
      }
    }
    pipeline = Yarrow::Assets::Pipeline.new(config)

    expect(pipeline.environment.paths).to include(Dir.pwd + "/assets/stylesheets")
    expect(pipeline.environment.paths).to include(Dir.pwd + "/assets/javascripts")
  end

  it "can append glob paths to the Sprockets environment" do
    config = {
      :assets => {
        :input_dir => "spec/fixtures/assets",
        :output_dir => "web/ui",
        :append_paths => "*"
      }
    }
    pipeline = Yarrow::Assets::Pipeline.new(config)

    expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/css")
    expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/js")
  end

  it "can append paths to pipeline instance" do
    config = {
      :assets => {
        :input_dir => "spec/fixtures/assets",
        :output_dir => "web/ui"
      }
    }
    pipeline = Yarrow::Assets::Pipeline.new(config)
    pipeline.append_paths << "css"

    expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/css")
    expect(pipeline.environment.paths).not_to include(Dir.pwd + "/spec/fixtures/assets/js")
  end

end
