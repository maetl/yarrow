require "spec_helper"

describe Yarrow::Content::ObjectType do
  it "assigns defaults when minimal data provided" do
    content_type = Yarrow::Content::ObjectType.from_name(:posts)
    expect(content_type.collection).to eq(:posts)
    expect(content_type.entity).to eq(:post)
    expect(content_type.extensions).to eq([".md", ".yml", ".htm"])
  end

  it "can be configured with a string" do
    content_type = Yarrow::Content::ObjectType.from_name("posts")
    expect(content_type.collection).to eq(:posts)
  end

  it "can be configured with a collection name" do
    properties = Yarrow::Content::ObjectType::Value.new(collection: :posts)
    content_type = Yarrow::Content::ObjectType.new(properties)
    expect(content_type.collection).to eq(:posts)
    expect(content_type.entity).to eq(:post)
  end

  it "can be configured with an entity name" do
    properties = Yarrow::Content::ObjectType::Value.new(entity: :post)
    content_type = Yarrow::Content::ObjectType.new(properties)
    expect(content_type.collection).to eq(:posts)
    expect(content_type.entity).to eq(:post)
  end

  it "can be configured with collection and entity names" do
    properties = Yarrow::Content::ObjectType::Value.new(collection: :blog, entity: :post)
    content_type = Yarrow::Content::ObjectType.new(properties)
    expect(content_type.collection).to eq(:blog)
    expect(content_type.entity).to eq(:post)
  end

  it "can be configured with a list of custom extensions" do
    properties = Yarrow::Content::ObjectType::Value.new(collection: :pages, extensions: [".md", ".txt"])
    content_type = Yarrow::Content::ObjectType.new(properties)
    expect(content_type.extensions).to eq([".md", ".txt"])
  end
end
