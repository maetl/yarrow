class ContentPages
  attr_reader :name

  def initialize(data)
    @name = data[:name]
  end
end

class ContentPage
  attr_reader :name

  def initialize(data)
    @name = data[:name]
  end
end

class ContentContainer
  attr_reader :name

  def initialize(data)
    @name = data[:name]
  end
end

describe Yarrow::Content::Expansion::FilenameMap do
  describe "sources/doctest" do
    let :graph do
      Yarrow::Content::Source.collect(fixture_path(self.class.description))
    end

    it "expands flat list of files" do
      policy = Yarrow::Content::Policy.from_spec(:content_pages)
      traversal = Yarrow::Content::Expansion::Traversal.new(graph, policy)
      traversal.expand

      node = graph.nodes(:collection).first
      expect(node[:collection]).to be_a(ContentPages)
      expect(node[:collection].name).to eq("doctest")

      nodes = graph.nodes(:resource)
      expect(nodes[0][:resource]).to be_a(ContentPage)
      expect(nodes[0][:resource].name).to eq("page1")
      expect(nodes[1][:resource]).to be_a(ContentPage)
      expect(nodes[1][:resource].name).to eq("page2")
      expect(nodes[2][:resource]).to be_a(ContentPage)
      expect(nodes[2][:resource].name).to eq("page3")
    end
  end

  describe "sources/pages" do
    let :graph do
      Yarrow::Content::Source.collect(fixture_path(self.class.description))
    end

    it "expands nested lists of files" do
      policy = Yarrow::Content::Policy.from_spec(:content_pages)
      traversal = Yarrow::Content::Expansion::Traversal.new(graph, policy)
      traversal.expand

      collection_nodes = graph.nodes(:collection)
      expect(collection_nodes.first[:collection]).to be_a(ContentPages)
      expect(collection_nodes.first[:collection].name).to eq("pages")
      expect(collection_nodes.last[:collection]).to be_a(ContentPages)
      expect(collection_nodes.last[:collection].name).to eq("children")

      parent_resource_nodes = collection_nodes.first.outgoing(:resource)
      expect(parent_resource_nodes.first[:resource]).to be_a(ContentPage)
      parent_names = parent_resource_nodes.map { |node| node[:resource].name }
      expect(parent_names.include?("about")).to be true
      expect(parent_names.include?("index")).to be true
      expect(parent_names.include?("one")).to be false
      expect(parent_names.include?("two")).to be false

      child_resource_nodes = collection_nodes.last.outgoing(:resource)
      expect(child_resource_nodes.first[:resource]).to be_a(ContentPage)
      parent_names = child_resource_nodes.map { |node| node[:resource].name }
      expect(parent_names.include?("one")).to be true
      expect(parent_names.include?("two")).to be true
      expect(parent_names.include?("about")).to be false
      expect(parent_names.include?("index")).to be false
    end

    it "expands nested files with separate container definition" do
      policy = Yarrow::Content::Policy.from_spec(:root, {
        container: :content_container,
        collection: :content_pages
      })
      traversal = Yarrow::Content::Expansion::Traversal.new(graph, policy)
      traversal.expand

      collection_nodes = graph.nodes(:collection)
      expect(collection_nodes.first[:collection]).to be_a(ContentContainer)
      expect(collection_nodes.first[:collection].name).to eq("pages")
      expect(collection_nodes.last[:collection]).to be_a(ContentPages)
      expect(collection_nodes.last[:collection].name).to eq("children")
    end
  end

  
  describe "sources/notebooks" do
    let :graph do
      Yarrow::Content::Source.collect(fixture_path(self.class.description))
    end

    it "expands nested files with separate container definition" do
      policy = Yarrow::Content::Policy.from_spec(:root, {
        container: :content_container,
        collection: :content_pages
      })
      traversal = Yarrow::Content::Expansion::Traversal.new(graph, policy)
      traversal.expand

      container_node, *collection_nodes = graph.nodes(:collection)
      expect(container_node[:collection]).to be_a(ContentContainer)
      expect(container_node[:collection].name).to eq("notebooks")
      
      collection_names = collection_nodes.map { |node| node[:collection].name }
      expect(collection_names.include?("notebook-a")).to be true
      expect(collection_names.include?("notebook-b")).to be true

      collections = collection_nodes.reduce({}) do |table, node|
        table[node[:collection].name] = node
        table
      end

      expect(collections["notebook-a"][:collection]).to be_a(ContentPages)
      expect(collections["notebook-b"][:collection]).to be_a(ContentPages)

      notebook_a = collections["notebook-a"].outgoing(:resource)
      notebook_a_names = notebook_a.map { |node| node[:resource].name }
      expect(notebook_a_names.count).to eq(2)
      expect(notebook_a_names.include?("a1")).to be true
      expect(notebook_a_names.include?("a2")).to be true

      notebook_b = collections["notebook-b"].outgoing(:resource)
      notebook_b_names = notebook_b.map { |node| node[:resource].name }
      expect(notebook_b_names.count).to eq(2)
      expect(notebook_b_names.include?("b1")).to be true
      expect(notebook_b_names.include?("b2")).to be true
    end
  end
end