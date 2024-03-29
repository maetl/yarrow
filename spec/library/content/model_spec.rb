require "spec_helper"

describe "yarrow content model" do
  it "loads a model from minimal default config" do
    content = Yarrow::Config::Content.new({
      module: "Test::Content",
      source_map: { blog: :post }
    })

    model = Yarrow::Content::Model.new(content)
    policy = model.policy_for(:blog)
    expect(policy.collection).to eq(:blog)
    expect(policy.entity).to eq(:post)
    expect(policy.expansion).to eq(:filename_map)
    expect(policy.source_path).to eq("blog")
  end

  it "loads a policy from explicit config" do
    content = Yarrow::Config::Content.new({
      module: "Test::Content",
      source_map: {
        root: {
          collection: :gallery,
          entity: :photo,
          expansion: :custom_strategy,
          match_path: "archive/photos"
        }
      }
    })

    model = Yarrow::Content::Model.new(content)
    policy = model.policy_for(:root)

    expect(policy.collection).to eq(:gallery)
    expect(policy.entity).to eq(:photo)
    expect(policy.expansion).to eq(:custom_strategy)
    #expect(policy.match_path).to eq("archive/photos")
  end
end
