describe Yarrow::Schema::Validator do
  describe "any type schema" do
    let(:anchor) do
      Yarrow::Schema::Validator.new([:href, :title, :target])
    end

    specify "checks a flat set of attributes" do
      expect(
        anchor.check({:href => "https://maetl.net", :title => "maetl", :target => "_blank"})
      ).to be_truthy
    end

    specify "missing attribute error" do
      expect {
        anchor.check({:href => "https://maetl.net"})
      }.to raise_error("wrong number of args")
    end

    specify "bad key error" do
      expect {
        anchor.check({:src => "https://maetl.net", :title => "maetl", :target => "_blank"})
      }.to raise_error("key does not exist")
    end
  end

  describe "type constraint schema" do
    let(:rect) do
      Yarrow::Schema::Validator.new({
        :shape => String,
        :x => Integer,
        :y => Integer,
        :w => Integer,
        :h => Integer
      })
    end

    specify "checks a flat set of attributes" do
      expect(
        rect.check({:shape => "rect", :x => 10, :y => 10, :w => 64, :h => 48})
      ).to be_truthy
    end

    specify "missing attribute error" do
      expect {
        rect.check({:shape => "rect"})
      }.to raise_error("wrong number of args")
    end

    specify "bad key error" do
      expect {
        rect.check({:mishape => "rect", :x => 10, :y => 10, :w => 64, :h => 48})
      }.to raise_error("key does not exist")
    end

    # specify "mismatching type error" do
    #   expect {
    #     rect.check({:shape => "rect", :x => "1", :y => "1", :w => "1", :h => "1"})
    #   }.to raise_error("")
    # end
  end
end

describe Yarrow::Schema::Value do
  it "builds struct from declaration" do
    Attrs = Yarrow::Schema::Value.new(:attr_a, :attr_b)
    attrs = Attrs.new(attr_a: "hello", attr_b: "world")
    expect(attrs.attr_a).to eq("hello")
    expect(attrs.attr_b).to eq("world")
    expect { attrs.attr_b = "welt" }.to raise_error(FrozenError)
  end

  it "compares by value" do
    Weight = Yarrow::Schema::Value.new(:value, :unit)
    w1 = Weight.new(value: 50, unit: "kgs")
    w2 = Weight.new(value: 50, unit: "kgs")
    expect(w1 === w2).to be(true)
  end
end

describe Yarrow::Schema::Entity do
  it "defines attribute accessors" do
    class DateType < Yarrow::Schema::Entity
      attribute :year, Integer
      attribute :month, Integer
      attribute :day, Integer
    end

    data = {
      :year =>  2021,
      :month => 2,
      :day => 22
    }

    dt = DateType.new(data)
    expect(dt.year).to eq(data[:year])
    expect(dt.month).to eq(data[:month])
    expect(dt.day).to eq(data[:day])
  end
end
