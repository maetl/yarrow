require "spec_helper"

module Test
  module Content

  end
end

class SourceMapPolicy < Yarrow::Schema::Entity[:sourcemap_policy]
  attribute :container, :string
end

class ConfigContent < Yarrow::Schema::Entity
  attribute :module, :string
  attribute :source_map, :sourcemap_policy
end

describe "configuration" do
  describe "content" do
    it "#new" do
      content = ConfigContent.new({
        module: "Test::Content",
        source_map: SourceMapPolicy.new(container: "SOURCEMAP")
      })
      expect(content.module).to eq("Test::Content")
    end

    xit "loads from hash" do
      content = Yarrow::Config::Content.new(CONTENT)
      expect(content.module).to eq("Test::Content")
      expect(content.source_map.container).to eq("SOURCEMAP")
    end
  end
end
