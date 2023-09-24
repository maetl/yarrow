describe Yarrow::Output::Build do
  # it "builds output target from config" do
  #   config = Yarrow::Config::Output.new(
  #     target: "web",
  #     generator: {
  #       engine: "liquid",
  #       template_dir: "templates",
  #       options: {
  #         error_mode: "strict"
  #       }
  #     },
  #     reconcile: {
  #       match: "collection/resource",
  #       manifest: {
  #         collection: {
  #           layout: "collection",
  #           scheme: "/{ancestors*}"
  #         }
  #       }
  #     }
  #   )

    
  # end

  it "builds reconciliation strategy from config" do
    config = Yarrow::Config::OutputReconcile.new({
      match: "collection/resource",
      manifest: {
        entries: {
          layout: "entries-template",
          scheme: "/entries/{name}"
        }
      }
    })

    expect(config.match).to eq("collection/resource")
    expect(config.manifest[:entries].layout).to eq("entries-template")
    expect(config.manifest[:entries].scheme).to eq("/entries/{name}")
  end

  it "builds reconciliation strategy from config shorthand" do
    config = Yarrow::Config::OutputReconcile.new({
      match: "collection/resource",
      manifest: {
        pages: true
      }
    })

    expect(config.match).to eq("collection/resource")
    expect(config.manifest[:pages].layout).to eq("pages")
    expect(config.manifest[:pages].scheme).to eq("/{ancestors*}")
  end
end