require "kramdown"

describe Yarrow::Format::Markdown do
  it "returns itself as the source" do
    md = Yarrow::Format::Markdown.new("This is a paragraph")

    expect(md.to_s).to eq("This is a paragraph")
  end

  it "converts markup to HTML" do
    md = Yarrow::Format::Markdown.new("This is a paragraph")

    expect(md.to_html).to eq("<p>This is a paragraph</p>\n")
  end

  it "parses links from the source" do
    md = Yarrow::Format::Markdown.new("This [doc](/doc) has [links](https://example.com).")

    expect(md.links).to be_a(Array)
    expect(md.links.length).to eq(2)
    expect(md.links.first).to eq("/doc")
    expect(md.links.last).to eq("https://example.com")
  end

  it "parses a title from h1 heading" do
    md = Yarrow::Format::Markdown.new("# Introduction\n\nWelcome to my document.")

    expect(md.title).to eq("Introduction")
  end
end
