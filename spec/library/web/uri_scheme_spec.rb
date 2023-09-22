require "spec_helper"

describe "URI scheme utilising addressable" do
  it "expands a basic URI template from params" do
    template = Addressable::Template.new("/{parent}/{name}")
    uri_path = template.expand({parent: "pages", name: "article-1"})

    expect(uri_path.to_s).to eq("/pages/article-1")
  end
end
