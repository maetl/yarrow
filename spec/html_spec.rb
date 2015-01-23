require "spec_helper"

describe Yarrow::HTML::AssetTags do

  class TemplateContext

    include Yarrow::HTML::AssetTags

    def config
      Hashie::Mash.new({
        :output_dir => 'spec/fixtures/assets',
        :manifest_path => 'manifest.json',
        :assets_path => ''
      })
    end

  end

  describe "#script_tags" do

    it "generates script tags for all JS assets in the manifest" do
      context = TemplateContext.new

      result = '<script src="/main-4362eea15558e73d3663de653cdeb81e.js"></script>'
      expect(context.script_tags).to eq result
    end

  end

  describe "#script_tag" do

    it "generates a JS script tag with a digest URL" do
      context = TemplateContext.new

      result = '<script src="/main-4362eea15558e73d3663de653cdeb81e.js"></script>'
      expect(context.script_tag(:asset => 'main.js')).to eq result
    end

    it "generates a script tag with the given src path" do
      context = TemplateContext.new

      result = '<script src="main.js"></script>'
      expect(context.script_tag(:src => 'main.js')).to eq result
    end

  end

  describe "#link_tag" do

    it "generates a CSS link tag with a digest url" do
      context = TemplateContext.new

      result = '<link href="/styles-7051b3cd15b430b483c4266d0519edf2.css" rel="stylesheet" type="text/css">'
      expect(context.link_tag(:asset => 'styles.css')).to eq result
    end

    it "generates a CSS link tag with the given href path" do
      context = TemplateContext.new

      result = '<link href="styles.css" rel="stylesheet" type="text/css">'
      expect(context.link_tag(:href => 'styles.css')).to eq result
    end

  end

end
