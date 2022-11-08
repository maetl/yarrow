describe Yarrow::Schema::Dictionary do
  describe "schema with optional fields using any type" do
    let(:anchor) do
      Yarrow::Schema::Dictionary.new({
        :href => :string,
        :title => :any,
        :target => :any
      })
    end

    specify "hash of attributes" do
      expect(
        anchor.cast({:href => "https://maetl.net", :title => "maetl", :target => "_blank"})
      ).to be_truthy
    end

    specify "skip any type attributes when not provided" do
      expect(anchor.cast({:href => "https://maetl.net"})).to be_truthy
    end

    specify "missing attribute error" do
      expect {
        anchor.cast({})
      }.to raise_error("[:href, :title, :target] wrong number of attributes")
    end

    specify "mismatching attribute error" do
      expect {
        anchor.cast({:href => "https://maetl.net", :src => "https://maetl.net"})
      }.to raise_error("attribute [:src] does not exist")
    end
  end

  describe "type constraint schema" do
    let(:rect) do
      Yarrow::Schema::Dictionary.new({
        :shape => :string,
        :x => :integer,
        :y => :integer,
        :w => :integer,
        :h => :integer
      })
    end

    specify "checks a flat set of attributes" do
      expect(
        rect.cast({:shape => "rect", :x => 10, :y => 10, :w => 64, :h => 48})
      ).to be_truthy
    end

    specify "missing attribute error" do
      expect {
        rect.cast({:shape => "rect"})
      }.to raise_error("[:x, :y, :w, :h] wrong number of attributes")
    end

    specify "bad key error" do
      expect {
        rect.cast({:mishape => "rect", :shape => "rect", :x => 10, :y => 10, :w => 64, :h => 48})
      }.to raise_error("attribute [:mishape] does not exist")
    end

    specify "mismatching type error" do
      expect {
        rect.cast({:shape => "rect", :x => "1", :y => "1", :w => "1", :h => "1"})
      }.to raise_error("String is not an instance of Integer")
    end
  end
end
