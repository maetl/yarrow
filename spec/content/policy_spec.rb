require "spec_helper"

describe Yarrow::Content::Policy do
  it "assigns defaults when minimal data provided" do
    content_type = Yarrow::Content::Policy.from_name(:posts)
    expect(content_type.container).to eq(:posts)
    expect(content_type.entity).to eq(:post)
    expect(content_type.extensions).to eq([".md", ".yml", ".htm"])
  end

  it "can be configured with a string" do
    content_type = Yarrow::Content::Policy.from_name("posts")
    expect(content_type.container).to eq(:posts)
  end

  it "can be configured with a container name" do
    properties = Yarrow::Content::Policy::Options.new(container: :posts)
    content_type = Yarrow::Content::Policy.new(properties)
    expect(content_type.container).to eq(:posts)
    expect(content_type.entity).to eq(:post)
  end

  it "can be configured with an entity name" do
    properties = Yarrow::Content::Policy::Options.new(entity: :post)
    content_type = Yarrow::Content::Policy.new(properties)
    expect(content_type.container).to eq(:posts)
    expect(content_type.entity).to eq(:post)
  end

  it "can be configured with container and entity names" do
    properties = Yarrow::Content::Policy::Options.new(container: :blog, entity: :post)
    content_type = Yarrow::Content::Policy.new(properties)
    expect(content_type.container).to eq(:blog)
    expect(content_type.entity).to eq(:post)
  end

  it "can be configured with a list of custom extensions" do
    properties = Yarrow::Content::Policy::Options.new(container: :pages, extensions: [".md", ".txt"])
    content_type = Yarrow::Content::Policy.new(properties)
    expect(content_type.extensions).to eq([".md", ".txt"])
  end
end
