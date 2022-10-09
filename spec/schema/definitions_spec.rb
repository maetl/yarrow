describe Yarrow::Schema::Definitions do
  WarningDef = Class.new
  Yarrow::Schema::Definitions.register(:warning, WarningDef)

  let (:type_container) do
    type_container = Class.new
    type_container.include(Yarrow::Schema::Definitions)
    type_container.new
  end

  it "resolves identifier to a registered type class" do
    expect(type_container.resolve_type(:warning)).to be_a(WarningDef.class)
  end

  it "raises an error when unregistered identifier is given" do
    expect {
      type_container.resolve_type(:object_model)
    }.to raise_error("object_model is not defined")
  end

  describe :defined_types do
    specify :any do
      expect(type_container.resolve_type(:string)).to be_a(Yarrow::Schema::Type::Any.class)
    end

    specify :string do
      expect(type_container.resolve_type(:string)).to be_a(String.class)
    end

    specify :integer do
      expect(type_container.resolve_type(:integer)).to be_a(Integer.class)
    end
  end
end
