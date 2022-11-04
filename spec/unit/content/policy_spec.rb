require "spec_helper"

describe Yarrow::Content::Policy do
  it "assigns defaults when minimal data provided" do
    policy = Yarrow::Content::Policy.from_spec(:blog, :post)

    expect(policy.container).to eq(:blog)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with a container name" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :posts})

    expect(policy.container).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with an entity name" do
    policy = Yarrow::Content::Policy.from_spec(:root, { entity: :post})

    expect(policy.container).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with container and entity names" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :gallery, entity: :photo})

    expect(policy.container).to eq(:gallery)
    expect(policy.entity).to eq(:photo)
  end

  it "uses default extensions if none provided" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :pages })

    expect(policy.extensions).to eq(Yarrow::Content::Policy::DEFAULT_EXTENSIONS)
  end

  it "can be configured with a list of custom extensions" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :pages, extensions: [".ascii", ".rtf"] })

    expect(policy.extensions).to eq([".ascii", ".rtf"])
  end

  it "uses default expansion if none provided" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :pages })

    expect(policy.expansion).to eq(Yarrow::Content::Policy::DEFAULT_EXPANSION)
  end
end
