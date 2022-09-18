require "kramdown"

module MediaType
  module Text
    def convert(input)
      if input.respond_to?(:to_str)
        input.to_s
      else
        raise "Conversion failed"
      end
    end
  end
end

module Format
  class Markdown
    include MediaType::Text

    def initialize(source)
      @source = convert(source)
      @format = Kramdown::Document.new(@source)
    end

    def to_s
      @source
    end

    def to_dom
      @format.root
    end

    def to_html
      @format.to_html
    end

    def links
      @links ||= select_links
    end

    def title
      @title ||= select_title
    end

    private

    def select_links
      stack = to_dom.children
      hrefs = [] # TODO: distinguish between internal and external

      while !stack.empty?
        next_el = stack.pop

        if next_el.type == :a
          hrefs << next_el.attr["href"]
        else
          stack.concat(next_el.children) if next_el.children
        end
      end

      hrefs.reverse
    end

    def select_title
      stack = to_dom.children

      while !stack.empty?
        next_el = stack.pop

        if next_el.type == :header and next_el.options[:level] == 1
          return next_el.options[:raw_text]
        else
          stack.concat(next_el.children) if next_el.children
        end
      end

      nil
    end
  end
end

describe "Markdown attr type specification" do
  it "raises conversion error from invalid input type" do
    expect { Format::Markdown.new(123) }.to raise_error("Conversion failed")
  end

  it "returns itself as the source" do
    md = Format::Markdown.new("This is a paragraph")

    expect(md.to_s).to eq("This is a paragraph")
  end

  it "converts markup to HTML" do
    md = Format::Markdown.new("This is a paragraph")

    expect(md.to_html).to eq("<p>This is a paragraph</p>\n")
  end

  it "parses links from the source" do
    md = Format::Markdown.new("This [doc](/doc) has [links](https://example.com).")

    expect(md.links).to be_a(Array)
    expect(md.links.length).to eq(2)
    expect(md.links.first).to eq("/doc")
    expect(md.links.last).to eq("https://example.com")
  end

  it "parses a title from h1 heading" do
    md = Format::Markdown.new("# Introduction\n\nWelcome to my document.")

    expect(md.title).to eq("Introduction")
  end
end

describe "meta schema" do
  it "can construct entity from data" do
    entity = Yarrow::Schema::Entity
    entity.attribute :title, :string

    obj = entity.new(title: "Object Instance")

    expect(obj.title).to eq("Object Instance")
  end
end
