require "spec_helper"

describe Yarrow::Content::Graph do
  def load_config_fixture(input_dir)
    Yarrow::Configuration.new(
      input_dir: "#{__dir__}/fixtures/sources/#{input_dir}"
    )
  end

  describe "pages" do
    let(:content) do
      Yarrow::Content::Graph.from_source(load_config_fixture("pages"))
    end

    it "reads a source graph from files" do
      expect(content.files.count).to eq(4)
      expect(content.directories.count).to eq(1)

      expect(
        Set.new(content.files.map { |f| f.props[:slug] })
      ).to eq(Set.new(['about', 'index', 'one', 'two']))
    end

    it "expands source files into collections" do
      class Page
        def initialize(props)
          @props = props
        end
      end

      content.expand_pages
    end
  end

  describe "collections" do
    it "reads a source graph from files" do
      config = load_config_fixture("collections")
      content = Yarrow::Content::Graph.from_source(config)

      expect(content.files.count).to eq(5)
      expect(content.directories.count).to eq(3)

      expect(
        Set.new(content.directories.map { |f| f.props[:slug] })
      ).to eq(Set.new(['articles', 'photos', 'posts']))
    end
  end
end
