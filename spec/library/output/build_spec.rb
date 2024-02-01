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

  describe "builds reconciliation strategy from nested config" do
    it "constructs manifest from defined attribute keys" do
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

    it "constructs manifest from boolean shorthand" do
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

    it "constructs manifest from symbol shorthand" do
      config = Yarrow::Config::OutputReconcile.new({
        match: "collection/resource",
        manifest: {
          pages: :index
        }
      })
  
      expect(config.match).to eq("collection/resource")
      expect(config.manifest[:pages].layout).to eq("index")
      expect(config.manifest[:pages].scheme).to eq("/{ancestors*}")
    end

    it "constructs manifest from string shorthand" do
      config = Yarrow::Config::OutputReconcile.new({
        match: "collection/resource",
        manifest: {
          pages: "/archive/{name}/show"
        }
      })
  
      expect(config.match).to eq("collection/resource")
      expect(config.manifest[:pages].layout).to eq("pages")
      expect(config.manifest[:pages].scheme).to eq("/archive/{name}/show")
    end
  end
end