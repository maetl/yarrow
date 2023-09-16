describe Yarrow::Format do
  describe "extension registry" do
    it "can append new media types to internal format registry" do
      class Abcdefg < Yarrow::Format::ContentType[".abcdefg", ".abcd"]
        include Yarrow::Format::Methods::FrontMatter

        def to_abcd
          :abcd
        end
      end

      contents_a = Yarrow::Format.read(fixture_path("format/custom.abcd"))
      contents_b = Yarrow::Format.read(fixture_path("format/custom.abcdefg"))

      expect(contents_a.document.to_s).to eq("ABCD")
      expect(contents_b.document.to_s).to eq("ABCDEFG")
      expect(contents_a.document.to_abcd).to eq(:abcd)
      expect(contents_b.document.to_abcd).to eq(:abcd)
    end
  end

  describe "Markdown#read" do
    it "can read .md files" do
      contents = Yarrow::Format.read(fixture_path("format/document.md"))

      expect(contents.document).to be_a(Yarrow::Format::Markdown)
    end

    it "can read .markdown files" do
      contents = Yarrow::Format.read(fixture_path("format/document.markdown"))

      expect(contents.document).to be_a(Yarrow::Format::Markdown)
    end

    it "can read .htm files" do
      contents = Yarrow::Format.read(fixture_path("format/document.htm"))

      expect(contents.document).to be_a(Yarrow::Format::Markdown)
    end
  end

  describe "Yaml#read" do
    it "can read .yml files" do
      contents = Yarrow::Format.read(fixture_path("format/data.yml"))

      expect(contents.metadata).to be_a(Yarrow::Format::Yaml)
    end

    it "can read .yaml files" do
      contents = Yarrow::Format.read(fixture_path("format/data.yaml"))

      expect(contents.metadata).to be_a(Yarrow::Format::Yaml)
    end
  end
end