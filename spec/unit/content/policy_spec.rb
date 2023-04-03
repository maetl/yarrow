require "spec_helper"

describe Yarrow::Content::Policy do
  it "assigns defaults when minimal data provided" do
    policy = Yarrow::Content::Policy.from_spec(:blog, :post)

    expect(policy.collection).to eq(:blog)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with a container name" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :posts})

    expect(policy.collection).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with an entity name" do
    policy = Yarrow::Content::Policy.from_spec(:root, { entity: :post})

    expect(policy.collection).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with container and entity names" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :gallery, entity: :photo})

    expect(policy.collection).to eq(:gallery)
    expect(policy.entity).to eq(:photo)
  end

  it "uses default extensions if none provided" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :pages })

    expect(policy.extensions).to eq(Yarrow::Content::Policy::DEFAULT_EXTENSIONS)
  end

  it "can be configured with a list of custom extensions" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :pages, extensions: [".ascii", ".rtf"] })

    expect(policy.extensions).to eq([".ascii", ".rtf"])
  end

  it "uses default expansion if none provided" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :pages })

    expect(policy.expansion).to eq(Yarrow::Content::Policy::DEFAULT_EXPANSION)
  end
end
