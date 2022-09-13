describe Yarrow::Content::Resource do

  # it "requires `id` attribute!" do
  #   resource = described_class.new(id: "id:1337")
  #   expect(resource.id).to eq("id:1337")
  # end

  it "requires `id` attribute" do
    expect { described_class.new({}) }.to raise_error("wrong number of args")
  end

  it "builds resource.url from frontmatter :url" do
    data = {
      id: "id:1337",
      name: "example-resource",
      title: "Example Resource",
      url: "/pages/example-resource",
      content: "..."
    }
    resource = described_class.from_frontmatter_url(data, :url)

    expect(resource.url).to eq("/pages/example-resource")
  end

  it "builds resource.url from frontmatter :permalink" do
    data = {
      id: "id:1337",
      name: "example-resource",
      title: "Example Resource",
      permalink: "/docs/example-resource",
      content: "..."
    }
    resource = described_class.from_frontmatter_url(data, :permalink)

    expect(resource.url).to eq("/docs/example-resource")
  end
end
