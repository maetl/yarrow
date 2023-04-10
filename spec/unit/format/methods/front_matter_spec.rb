require "spec_helper"

module Custom
  class Downcase
    include Yarrow::Format::Methods::FrontMatter

    def initialize(source)
      @source = source.downcase
    end

    def to_s
      @source
    end
  end
end

describe Yarrow::Format::Methods::FrontMatter do
  describe :read do
    it "reads embedded format when included in a mediatype object" do
      contents = Custom::Downcase.read(fixture_path("tools/front_matter/page.yfm"))

      expect(contents.document.to_s).to eq "<p>split page content.</p>"
      expect(contents.metadata[:layout]).to eq "page"
      expect(contents.metadata[:title]).to eq "YAML Front Matter"
    end
  end

  describe :read_yfm do
    include Yarrow::Format::Methods::FrontMatter::ClassMethods

    it "reads raw parts from a frontmatter formatted text file" do
      content, meta = read_yfm(fixture_path("tools/front_matter/page.yfm"))

      expect(content).to eq "<p>Split page content.</p>"
      expect(meta[:layout]).to eq "page"
      expect(meta[:title]).to eq "YAML Front Matter"
    end
  end

  describe :extract_yfm do
    include Yarrow::Format::Methods::FrontMatter::ClassMethods

    it "extracts raw parts from a frontmatter formatted string" do
      text = load_fixture("tools/front_matter/page.yfm")
  
      content, meta = extract_yfm(text)
  
      expect(content).to eq "<p>Split page content.</p>"
      expect(meta["layout"]).to eq "page"
      expect(meta["title"]).to eq "YAML Front Matter"
    end
  
    it "extracts raw text from a string without frontmatter delimiters" do
      text = load_fixture("tools/front_matter/missing.yfm")
  
      content, meta = extract_yfm(text)
  
      expect(content).to eq "<p>Page content only. No delimiter</p>"
      expect(meta).to eq nil
    end
  
    it "extracts raw text from a string with malformed frontmatter syntax" do
      text = load_fixture("tools/front_matter/malformed.yfm")
  
      content, meta = extract_yfm(text)
  
      expect(content).to eq "<p>Page content.</p>"
      expect(meta).to eq nil
    end
  end
end
