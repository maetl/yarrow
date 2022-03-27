require "spec_helper"

describe Yarrow::Content::SourceCollector do
  describe "#collect" do
    let(:config) do
      load_config_fixture("pages")
    end

    specify "descriptor labels" do
      local_file_source = Yarrow::Content::SourceCollector.collect(config.content_dir)

      expect(
        Set.new(local_file_source.nodes.map { |n| n.label })
      ).to eq(Set.new([:root, :file, :directory]))

      expect(
        Set.new(local_file_source.edges.map { |e| e.label })
      ).to eq(Set.new([:child]))
    end

    specify "directory schema" do
      local_file_source = Yarrow::Content::SourceCollector.collect(config.content_dir)
      dir_props = local_file_source.n(:directory).first.props
      # TODO: collapse path and entry, consider place for stat/mtime
      expect(dir_props).to have_key(:name)
      expect(dir_props).to have_key(:slug)
      expect(dir_props).to have_key(:path)
      expect(dir_props).to have_key(:entry)
    end

    specify "file schema" do
      local_file_source = Yarrow::Content::SourceCollector.collect(config.content_dir)
      file_props = local_file_source.n(:file).first.props
      # TODO: collapse path and entry, consider place for stat/mtime
      expect(file_props).to have_key(:name)
      expect(file_props).to have_key(:slug)
      expect(file_props).to have_key(:path)
      expect(file_props).to have_key(:entry)
    end
  end
end
