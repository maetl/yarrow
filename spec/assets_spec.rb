require "spec_helper"

describe Yarrow::Assets::Manifest do

  it "initializes with empty values if manifest path not found" do
    config = {
      :output_dir => "_site",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.exists?("main.js")).to eq false
  end

  it "initializes with empty values if empty config given" do
    config = {}
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.exists?("main.js")).to eq false
  end

  it "loads values from manifest file" do
    config = {
      :output_dir => "spec/fixtures/assets",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.exists?("main.js")).to eq true
  end

  it "maps logical path to digest path" do
    config = {
      :output_dir => "spec/fixtures/assets",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.digest_path("main.js")).to eq "main-4362eea15558e73d3663de653cdeb81e.js"
  end

  it "maps logical path to file object" do
    config = {
      :output_dir => "spec/fixtures/assets",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    file = manifest.file("main.js")
    expect(file['digest']).to eq "4362eea15558e73d3663de653cdeb81e"
    expect(file['logical_path']).to eq "main.js"
    expect(file['mtime']).to eq "2014-12-22T16:40:34+11:00"
  end

  it "maps logical paths" do
    config = {
      :output_dir => "spec/fixtures/assets",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.logical_paths.size).to eq 2
    expect(manifest.logical_paths.first).to eq "styles.css"
    expect(manifest.logical_paths.last).to eq "main.js"
  end

  it "maps digest paths" do
    config = {
      :output_dir => "spec/fixtures/assets",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.digest_paths.size).to eq 2
    expect(manifest.digest_paths.first).to eq "styles-7051b3cd15b430b483c4266d0519edf2.css"
    expect(manifest.digest_paths.last).to eq "main-4362eea15558e73d3663de653cdeb81e.js"
  end

  it "maps asset files" do
    config = {
      :output_dir => "spec/fixtures/assets",
      :manifest_path => "manifest.json"
    }
    manifest = Yarrow::Assets::Manifest.new(config)

    expect(manifest.files.size).to eq 2
    expect(manifest.files.first['digest']).to eq "7051b3cd15b430b483c4266d0519edf2"
    expect(manifest.files.last['digest']).to eq "4362eea15558e73d3663de653cdeb81e"
  end

end

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
