describe Yarrow::Schema::Entity do
  class DateType < Yarrow::Schema::Entity
    attribute :year, :integer
    attribute :month, :integer
    attribute :day, :integer
  end

  it "defines attribute accessors" do
    data = {
      :year =>  2021,
      :month => 2,
      :day => 22
    }

    dt = DateType.new(data)
    expect(dt.year).to eq(2021)
    expect(dt.month).to eq(2)
    expect(dt.day).to eq(22)
  end

  it "converts attributes to hash" do
    data = {
      :year =>  2021,
      :month => 2,
      :day => 22
    }

    dt = DateType.new(data)
    expect(dt.to_h).to eq(data)
  end

  it "raises error when missing required attribute" do
    data = {
      :year =>  2021,
      :month => 2
    }

    # TODO: "missing declared attribute `day`"
    expect { DateType.new(data) }.to raise_error(
      "wrong number of attributes"
    )
  end

  it "raises error when given unregistered attribute" do
    data = {
      :year =>  2021,
      :month => 2,
      :day => 22,
      :iso8601 => "2021-02-22"
    }

    # TODO: "iso8601 not a declared attribute"
    expect { DateType.new(data) }.to raise_error(
      "attribute does not exist"
    )
  end

  it "merges two instances" do
    date1 = DateType.new({:year =>  2021, :month => 2, :day => 22})
    date2 = DateType.new({:year =>  2022, :month => 2, :day => 22})
    date3 = date1.merge(date2)

    expect(date3.year).to eq(2022)
  end

  it "merges instances recursively" do
    class PubTitleType < Yarrow::Schema::Entity
      attribute :text, :string
    end

    class PubURIType < Yarrow::Schema::Entity
      attribute :path, :string
      attribute :scheme, :symbol
    end

    Yarrow::Schema::Definitions.register(
      :pub_title,
      Yarrow::Schema::Types::Instance.of(PubTitleType).accept(Hash)
    )

    Yarrow::Schema::Definitions.register(
      :pub_uri,
      Yarrow::Schema::Types::Instance.of(PubURIType).accept(Hash)
    )

    class Publication < Yarrow::Schema::Entity
      attribute :title, :pub_title
      attribute :url, :pub_uri
    end

    pub1 = Publication.new(
      title: PubTitleType.new(text: "Publication 1"),
      url: PubURIType.new(path: "/pub1", scheme: :file)
    )

    pub2 = Publication.new(
      title: PubTitleType.new(text: "Publication 2"),
      url: PubURIType.new(path: "/pub1", scheme: :http)
    )

    pub3 = pub1.merge(pub2)

    expect(pub3.title.text).to eq("Publication 2")
    expect(pub3.url.path).to eq("/pub1")
    expect(pub3.url.scheme).to eq(:http)
  end

  it "registers type definition from class inheritance" do
    class WidgetPart < Yarrow::Schema::Entity[:widget_part]
      attribute :label, :string
    end

    class WidgetDevice < Yarrow::Schema::Entity[:widget_device]
      attribute :label, :string
    end

    class Widget < Yarrow::Schema::Entity
      attribute :part, :widget_part
      attribute :device, :widget_device
    end

    part = WidgetPart.new(label: "part.1")
    device = WidgetDevice.new(label: "device.1")
    widget = Widget.new(part: part, device: device)

    expect(widget.part.label).to eq("part.1")
    expect(widget.device.label).to eq("device.1")
  end
end
