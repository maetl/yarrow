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
      "[:day] wrong number of attributes"
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
      "attribute [:iso8601] does not exist"
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

  it "registers type definition automatically from class const" do
    class WidgetPart < Yarrow::Schema::Entity
      attribute :label, :string
    end

    class WidgetDevice < Yarrow::Schema::Entity
      attribute :label, :string
    end

    class Widget < Yarrow::Schema::Entity
      attribute :part, :widget_part
      attribute :device, :widget_device
    end

    widget = Widget.new(
      part: WidgetPart.new(label: "part.1"),
      device: WidgetDevice.new(label: "device.1")
    )

    expect(widget.part.label).to eq("part.1")
    expect(widget.device.label).to eq("device.1")
  end

  it "registers type definition manually from defined label" do
    class XWidgetPart < Yarrow::Schema::Entity[:w_part]
      attribute :label, :string
    end

    class XWidgetDevice < Yarrow::Schema::Entity[:w_device]
      attribute :label, :string
    end

    class XWidget < Yarrow::Schema::Entity
      attribute :part, :w_part
      attribute :device, :w_device
    end

    widget = XWidget.new(
      part: XWidgetPart.new(label: "part.1"),
      device: XWidgetDevice.new(label: "device.1")
    )

    expect(widget.part.label).to eq("part.1")
    expect(widget.device.label).to eq("device.1")
  end

  it "can serialize entities with compound attributes from a hash" do
    class Address < Yarrow::Schema::Entity
      attribute :city, :string
      attribute :street, :string
      attribute :postcode, :string
    end

    class Person < Yarrow::Schema::Entity
      attribute :first_name, :string
      attribute :last_name, :string
      attribute :billing_address, :address

      def full_name
        "#{first_name} #{last_name}" 
      end
    end

    person = Person.new({
      first_name: "Erika",
      last_name: "Mustermann",
      billing_address: {
        city: "Berlin",
        street: "Wrangelstraße 71",
        postcode: "10997"
      }
    })

    expect(person.full_name).to eq("Erika Mustermann")
    expect(person.billing_address.city).to eq("Berlin")
  end
end
