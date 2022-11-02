describe "yarrow content model" do
  it "loads a policy from explicit catch-all config" do
    config_spec = Yarrow::Content::ContentSpec.new(
      namespace: "Site",
      model: {
        root: Yarrow::Content::ContentPolicy.new(
          expansion: :tree,
          dir: "*",
          file: "*.md",
          :container => :pages,
          :record => :page
        )
      }
    )

    model = Yarrow::Content::Model.new(config_spec)

    expect(model.policy_for(:root).expansion).to eq(:tree)
  end

  xit "loads a model from minimal default config" do
    config_spec = Yarrow::Content::ContentSpec.new(
      namespace: "",
      model: {
        root: Yarrow::Content::ContentPolicy.new(
          expansion: :tree,
          container: :pages
        )
      }
    )

    model = Yarrow::Content::Model.new(config_spec)

    expect(model.policy_for(:root).expansion).to eq(:tree)
  end
end
