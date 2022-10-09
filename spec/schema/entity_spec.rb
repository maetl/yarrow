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
end
