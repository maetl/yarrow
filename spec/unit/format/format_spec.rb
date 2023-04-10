describe Yarrow::Format do
  describe "extension registry" do
    it "can append new media types to internal format registry" do
      class Abcdefg < Yarrow::Format::ContentType[".abcdefg", ".abcd"]
        include Yarrow::Format::Methods::FrontMatter

        def to_abcd
          :abcd
        end
      end

      contents_a = Yarrow::Format.read(__dir__ + "/fixtures/custom.abcd")
      contents_b = Yarrow::Format.read(__dir__ + "/fixtures/custom.abcdefg")

      expect(contents_a.document.to_s).to eq("ABCD")
      expect(contents_b.document.to_s).to eq("ABCDEFG")
      expect(contents_a.document.to_abcd).to eq(:abcd)
      expect(contents_b.document.to_abcd).to eq(:abcd)
    end
  end

  describe "Markdown#read" do
    it "can read .md files" do
      contents = Yarrow::Format.read(__dir__ + "/fixtures/document.md")

      expect(contents.document).to be_a(Yarrow::Format::Markdown)
    end

    it "can read .markdown files" do
      contents = Yarrow::Format.read(__dir__ + "/fixtures/document.markdown")

      expect(contents.document).to be_a(Yarrow::Format::Markdown)
    end

    it "can read .htm files" do
      contents = Yarrow::Format.read(__dir__ + "/fixtures/document.htm")

      expect(contents.document).to be_a(Yarrow::Format::Markdown)
    end
  end

  describe "Yaml#read" do
    it "can read .yml files" do
      contents = Yarrow::Format.read(__dir__ + "/fixtures/data.yml")

      expect(contents.metadata).to be_a(Yarrow::Format::Yaml)
    end

    it "can read .yaml files" do
      contents = Yarrow::Format.read(__dir__ + "/fixtures/data.yaml")

      expect(contents.metadata).to be_a(Yarrow::Format::Yaml)
    end
  end
end