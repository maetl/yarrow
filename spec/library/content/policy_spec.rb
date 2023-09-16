require "spec_helper"

describe Yarrow::Content::Policy do
  describe "configuration shorthand" do
    it "defines default policy from label" do
      policy = Yarrow::Content::Policy.from_spec(:pages)

      expect(policy.container).to eq(:pages)
      expect(policy.collection).to eq(:pages)
      expect(policy.entity).to eq(:page)
      expect(policy.source_path).to eq(".")
    end

    it "defines entity from symbol value" do
      policy = Yarrow::Content::Policy.from_spec(:blog, :post)

      expect(policy.container).to eq(:blog)
      expect(policy.collection).to eq(:blog)
      expect(policy.entity).to eq(:post)
      expect(policy.source_path).to eq("blog")
    end

    it "defines source from string value" do
      policy = Yarrow::Content::Policy.from_spec(:posts, "archive")

      expect(policy.container).to eq(:posts)
      expect(policy.collection).to eq(:posts)
      expect(policy.entity).to eq(:post)
      expect(policy.source_path).to eq("archive")
    end
  end

  it "can be configured with a collection name" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :posts})

    expect(policy.container).to eq(:posts)
    expect(policy.collection).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with an entity name" do
    policy = Yarrow::Content::Policy.from_spec(:root, { entity: :post})

    expect(policy.container).to eq(:posts)
    expect(policy.collection).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with a container name" do
    policy = Yarrow::Content::Policy.from_spec(:posts, { container: :feed})

    expect(policy.container).to eq(:feed)
    expect(policy.collection).to eq(:posts)
    expect(policy.entity).to eq(:post)
  end

  it "can be configured with collection and entity names" do
    policy = Yarrow::Content::Policy.from_spec(:root, { collection: :gallery, entity: :photo})

    expect(policy.container).to eq(:gallery)
    expect(policy.collection).to eq(:gallery)
    expect(policy.entity).to eq(:photo)
  end

  it "can be configured with container and collection names" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :gallery, collection: :photos})

    expect(policy.container).to eq(:gallery)
    expect(policy.collection).to eq(:photos)
    expect(policy.entity).to eq(:photo)
  end

  it "can be configured with container, collection and entity names" do
    policy = Yarrow::Content::Policy.from_spec(:root, { container: :gallery, collection: :exhibition, entity: :photo})

    expect(policy.container).to eq(:gallery)
    expect(policy.collection).to eq(:exhibition)
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
