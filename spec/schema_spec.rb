describe Yarrow::Schema::Validator do
  Type = Yarrow::Schema::Type

  describe "any type schema" do
    let(:anchor) do
      Yarrow::Schema::Validator.new({
        :href => Type::Any,
        :title => Type::Any,
        :target => Type::Any
      })
    end

    specify "hash of attributes" do
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
  it "empty definition error" do
    expect { Yarrow::Schema::Value.new }.to raise_error(ArgumentError)
  end

  it "builds struct from slot declaration" do
    Slots = Yarrow::Schema::Value.new(:first, :last)
    slots = Slots.new(first: "hello", last: "world")
    expect(slots.first).to eq("hello")
    expect(slots.last).to eq("world")
    #expect { attrs.attr_b = "welt" }.to raise_error(FrozenError)
  end

  it "builds struct from field declaration" do
    Fields = Yarrow::Schema::Value.new(name: String, email: String)
    fields = Fields.new(name: "maetl", email: "me@maetl.net")
    expect(fields.name).to eq("maetl")
    expect(fields.email).to eq("me@maetl.net")
    #expect { attrs.attr_b = "welt" }.to raise_error(FrozenError)
  end

  it "compares by value" do
    Weight = Yarrow::Schema::Value.new(:value, :unit)
    w1 = Weight.new(value: 50, unit: "kgs")
    w2 = Weight.new(value: 50, unit: "kgs")
    expect(w1 == w2).to be(true)
    expect(w1 === w2).to be(true)
    expect(w1).to eq(w2)
  end

  it "supports ruby struct initializer" do
    Length = Yarrow::Schema::Value.new(:size, :unit)
    len = Length.new(500, "cm")
    expect(len.size).to eq(500)
    expect(len.unit).to eq("cm")
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
