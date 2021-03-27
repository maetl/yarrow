require "spec_helper"

describe Yarrow::Tools::FrontMatter do

  include Yarrow::Tools::ContentUtils

  it "test_read_split_content" do
    content, meta = read(File.dirname(__FILE__) + "/fixtures/tools/front_matter/page.yfm")

    expect(content).to eq "<p>Split page content.</p>"
    expect(meta[:layout]).to eq "page"
    expect(meta[:title]).to eq "YAML Front Matter"
  end

  it "test_extract_split_content" do
    text = File.read(File.dirname(__FILE__) + "/fixtures/tools/front_matter/page.yfm")

    content, meta = extract_yfm(text)

    expect(content).to eq "<p>Split page content.</p>"
    expect(meta["layout"]).to eq "page"
    expect(meta["title"]).to eq "YAML Front Matter"
  end

  it "test_missing_delimiter" do
    text = File.read(File.dirname(__FILE__) + "/fixtures/tools/front_matter/missing.yfm")

    content, meta = extract_yfm(text)

    expect(content).to eq "<p>Page content only. No delimiter</p>"
    expect(meta).to eq nil
  end

  it "test_malformed_yaml" do
    text = File.read(File.dirname(__FILE__) + "/fixtures/tools/front_matter/malformed.yfm")

    content, meta = extract_yfm(text)

    expect(content).to eq "<p>Page content.</p>"
    expect(meta).to eq nil
  end
end
