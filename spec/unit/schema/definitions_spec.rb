describe Yarrow::Schema::Definitions do
  WarningDef = Class.new
  Yarrow::Schema::Definitions.register(:warning, Yarrow::Schema::Types::Instance.of(WarningDef))

  let (:type_container) do
    type_container = Class.new
    type_container.include(Yarrow::Schema::Definitions)
    type_container.new
  end

  it "resolves identifier to a registered type class" do
    expect(type_container.resolve_type(:warning)).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(:warning).unit).to be(WarningDef)
  end

  it "raises an error when unregistered identifier is given" do
    expect {
      type_container.resolve_type(:object_model)
    }.to raise_error("object_model is not defined")
  end

  describe :defined_types do
    specify :any do
      expect(type_container.resolve_type(:any)).to be_a(Yarrow::Schema::Types::Any)
    end

    specify :string do
      expect(type_container.resolve_type(:string)).to be_a(Yarrow::Schema::Types::Instance)
    end

    specify :integer do
      expect(type_container.resolve_type(:integer)).to be_a(Yarrow::Schema::Types::Instance)
    end

    specify :symbol do
      expect(type_container.resolve_type(:symbol)).to be_a(Yarrow::Schema::Types::Instance)
    end

    specify :path do
      expect(type_container.resolve_type(:path)).to be_a(Yarrow::Schema::Types::Instance)
    end
  end

  describe :register_outside_module_scope do
    specify :define_types do
      Money = Class.new

      Yarrow::Schema.define do
        type :money, Yarrow::Schema::Types::Instance.of(Money)
      end

      expect(type_container.resolve_type(:money).unit).to be(Money)
    end
  end
end
