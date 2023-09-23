require "spec_helper"

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

  it "converts instances with list attributes to hash" do
    Yarrow::Schema::Definitions.register(
      :alphabet,
      Yarrow::Schema::Types::List.of(Symbol)
    )

    class SyntaxFragment < Yarrow::Schema::Entity
      attribute :name, :string
      attribute :symbols, :alphabet
      #attribute :expr, :array
    end

    fragment = SyntaxFragment.new(
      name: "fragment-1",
      symbols: [:a, :b, :c, :d]
      #expr: [[:a, "A"], 100, :b, "tail"]
    )

    converted = fragment.to_h
    expect(converted[:name]).to eq("fragment-1")
    expect(converted[:symbols].first).to eq(:a)
    expect(converted[:symbols].last).to eq(:d)
    # TODO: fix interactions with Any type and entity
    # expect(converted[:expr].first.last).to eq("A")
    # expect(converted[:expr][1]).to eq(100)
    # expect(converted[:expr][1]).to eq(:b)
    # expect(converted[:expr].last).to eq("tail")
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

  it "can serialize entities with compound attributes from hash" do
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

  it "can serialize entities with compound attributes from array" do
    class LineItem < Yarrow::Schema::Entity
      attribute :sku, :string
      attribute :qty, :integer
    end

    Yarrow::Schema::Definitions.register(
      :line_items,
      Yarrow::Schema::Types::List.of(LineItem).accept_elements(Hash)
    )

    class Cart < Yarrow::Schema::Entity
      attribute :session_id, :string
      attribute :items, :line_items
    end

    cart = Cart.new({
      session_id: "19y34234239472934023jshdf",
      items: [
        { sku: "BOOK123", qty: 3 },
        { sku: "GAME456", qty: 2 }
      ]
    })

    expect(cart.session_id).to eq("19y34234239472934023jshdf")
    expect(cart.items.count).to eq(2)
    expect(cart.items.first).to be_a(LineItem)
    expect(cart.items.last).to be_a(LineItem)
    expect(cart.items.first.sku).to eq("BOOK123")
    expect(cart.items.first.qty).to eq(3)
    expect(cart.items.last.sku).to eq("GAME456")
    expect(cart.items.last.qty).to eq(2)
  end
end
