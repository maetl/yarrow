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

  describe :parse do
    include Yarrow::Format::Methods::FrontMatter::ClassMethods
  
    it "can parse Markdown frontmatter with standard delimiters" do
      content, meta = parse("---\ntitle: Hello\n---\n\n# Hello title")

      expect(content).to eq("# Hello title")
    end

    it "can parse Markdown frontmatter with yaml eof delimiter" do
      content, meta = parse("---\ntitle: Hello\n...\n\n# Hello title")

      expect(content).to eq("# Hello title")
    end

    it "can parse TOML frontmatter with Hugo and Middleman delimiters" do
      content, meta = parse("+++\ntitle = \"Hello\"\n+++\n\n# Hello title")

      expect(content).to eq("# Hello title")
      expect(meta["title"]).to eq("Hello")
    end

    it "can parse JSON frontmatter with Middleman delimiters" do
      content, meta = parse(";;;\n\"title\": \"Hello\"\n;;;\n\n# Hello title")

      expect(content).to eq("# Hello title")
    end

    it "can parse JSON frontmatter with Hugo delimiters" do
      content, meta = parse("{\n\"title\": \"Hello\"\n}\n\n# Hello title")

      expect(content).to eq("# Hello title")
    end

    it "passes through raw content when no delimiters are detected" do
      content, meta = parse("# Hello world title\n\nHello intro paragraph.")

      expect(content).to eq("# Hello world title\n\nHello intro paragraph.")
      expect(meta).to be_nil
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
