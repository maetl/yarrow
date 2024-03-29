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
    Fields = Yarrow::Schema::Value.new(name: :string, email: :string)
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

  it "supports class declaration syntax" do
    class Temperature < Yarrow::Schema::Value.new(:value, :unit)
      def to_fahrenheit
        case unit
        when :celsius
          (value * 1.8) + 32
        when :kelvin
          (value - 273.15) * 1.8 + 32
        end
      end
    end

    winter_low = Temperature.new(-5, :celsius)
    expect(winter_low.to_fahrenheit).to eq(23)

    liquid_nitrogen = Temperature.new(77.36, :kelvin)
    expect(liquid_nitrogen.to_fahrenheit).to be_within(0.1).of(-320.422)
  end

  it "merges values with any type" do
    Pegboard = Yarrow::Schema::Value.new(:first, :last)

    start = Pegboard.new(:square, :square)
    merged = start.merge(Pegboard.new(nil, :triangle))

    expect(merged.first).to be :square
    expect(merged.last).to be :triangle
  end

  it "manually registers the value as a defined type" do
    ColorVal = Yarrow::Schema::Value.new(r: :integer, g: :integer, b: :integer).register(:color_val)

    Div = Yarrow::Schema::Value.new(background_color: :color_val, display: :string)

    flex = Div.new(
      background_color: ColorVal.new(r: 255, g: 255, b: 255),
      display: "flex"
    )

    block = Div.new(
      background_color: {
        r: 255,
        g: 255,
        b: 255
      },
      display: "block"
    )

    expect(flex.display).to eq("flex")
    expect(block.display).to eq("block")

    expect(flex.background_color == block.background_color).to be(true)
    expect(flex.background_color.r).to eq(255)
    expect(block.background_color.r).to eq(255)
  end

  it "automatically registers class-declared value as a defined type" do
    class Channel < Yarrow::Schema::Value.new(mix: :integer); end

    class Stereo < Yarrow::Schema::Value.new(left: :channel, right: :channel)
      def center
        Stereo.new(left: { mix: 50 }, right: { mix: 50 })
      end
    end

    mixer = Stereo.new(left: { mix: 10 }, right: { mix: 90 })

    expect(mixer.left.mix).to eq(10)
    expect(mixer.right.mix).to eq(90)

    centered = mixer.center

    expect(centered.left.mix).to eq(50)
    expect(centered.right.mix).to eq(50)
  end
end
