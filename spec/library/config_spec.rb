require "spec_helper"

describe Yarrow::Config::Content do
  it "#new" do
    content = Yarrow::Config::Content.new({
      module: "Test::Content",
      source_map: { root: { container: :pages, entity: :page } }
    })
    expect(content.module).to eq("Test::Content")
    expect(content.source_map[:root][:container]).to eq(:pages)
    expect(content.source_map[:root][:entity]).to eq(:page)
  end
end

describe Yarrow::Config::Output do
  it "#new" do
    output = Yarrow::Config::Output.new({
      target: "web",
      generator: {
        engine: "liquid",
        template_dir: "templates",
        options: {}
      },
      reconcile: {
        match: "collection",
        manifest: {
          pages: {
            layout: "index",
            scheme: "/drafts/{name}"
          },
          page: {
            layout: "document",
            scheme: "/draft/{name}"
          }
        }
      }
    })

    expect(output.target).to eq("web")
    expect(output.generator.engine).to eq("liquid")
    expect(output.reconcile.match).to eq("collection")
  end
end
