require "spec_helper"

describe Yarrow::Assets::Pipeline do

  describe "#environment" do

    it "initializes with a base asset path" do
      config = {
        :input_dir => "spec/fixtures/assets"
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)

      expect(pipeline.environment.paths).not_to include("stylesheets")
    end

    it "can append paths to the Sprockets environment" do
      config = {
        :input_dir => "assets",
        :append_paths => ["stylesheets", "javascripts"]
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)

      expect(pipeline.environment.paths).to include(Dir.pwd + "/assets/stylesheets")
      expect(pipeline.environment.paths).to include(Dir.pwd + "/assets/javascripts")
    end

    it "can append string paths to the Sprockets environment" do
      config = {
        :input_dir => "spec/fixtures/assets",
        :append_paths => "css"
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)

      expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/css")
    end

    it "can append glob paths to the Sprockets environment" do
      config = {
        :input_dir => "spec/fixtures/assets",
        :append_paths => "*"
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)

      expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/css")
      expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/js")
    end

    it "can append paths to pipeline instance" do
      config = {
        :input_dir => "spec/fixtures/assets",
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)
      pipeline.append_paths << "css"

      expect(pipeline.environment.paths).to include(Dir.pwd + "/spec/fixtures/assets/css")
      expect(pipeline.environment.paths).not_to include(Dir.pwd + "/spec/fixtures/assets/js")
    end

  end

  describe "#compile" do

    after(:each) do
      system "rm -rf web"
    end

    it "can compile an explicit bundle to a manifest" do
      config = {
        :input_dir => "spec/fixtures/assets",
        :output_dir => "web/ui",
        :append_paths => "*"
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)

      pipeline.compile(["sans.css"])

      digest_path = pipeline.environment["sans.css"].digest_path

      expect(File.exist?("web/ui/manifest.json")).to eq true
      expect(File.exist?("web/ui/#{digest_path}")).to eq true
    end

    it "can compile glob bundles to a manifest" do
      config = {
        :input_dir => "spec/fixtures/assets",
        :output_dir => "web/ui",
        :append_paths => "css"
      }
      pipeline = Yarrow::Assets::Pipeline.new(config)

      pipeline.compile(["css/*.css"])

      digest_path = pipeline.environment["sans.css"].digest_path

      expect(File.exist?("web/ui/manifest.json")).to eq true
      expect(File.exist?("web/ui/#{digest_path}")).to eq true
    end

  end

end
