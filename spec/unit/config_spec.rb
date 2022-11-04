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
