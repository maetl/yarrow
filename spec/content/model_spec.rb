describe "yarrow content model" do
  it "loads a policy from explicit catch-all config" do
    config_spec = Yarrow::ContentConfig::ContentSpec.new(
      namespace: "Site",
      model: {
        root: Yarrow::ContentConfig::ContentPolicy.new(
          expansion: :tree,
          folder: "*",
          file: "*.md",
          :container => "IndexPage",
          :entity => "ContentPage"
        )
      }
    )

    model = Yarrow::ContentConfig::Model.new(config_spec)

    expect(model.policy_for(:root).expansion).to eq(:tree)
  end
end
