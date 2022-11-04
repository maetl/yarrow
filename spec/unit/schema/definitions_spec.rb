require "spec_helper"

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
    }.to raise_error("type object_model is not defined")
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

    specify :array do
      expect(type_container.resolve_type(:array)).to be_a(Yarrow::Schema::Types::List)
      #expect(type_container.resolve_type(:array).unit).to be_a(Yarrow::Schema::Types::Instance)
    end
  end

  specify :compound_list do
    Vector3D = Class.new
    Yarrow::Schema::Definitions.register(:quaternion, Yarrow::Schema::Types::List.of(Vector3D))

    expect(type_container.resolve_type(:quaternion)).to be_a(Yarrow::Schema::Types::List)
    expect(type_container.resolve_type(:quaternion).unit).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(:quaternion).unit.unit).to be(Vector3D)
  end

  specify :compound_list_with_runtime_template do
    expect(type_container.resolve_type(list: :integer)).to be_a(Yarrow::Schema::Types::List)
  end

  specify :compound_map_with_symbolized_keys do
    SettingFlag = Class.new
    Yarrow::Schema::Definitions.register(:flags, Yarrow::Schema::Types::Map.of(SettingFlag))

    expect(type_container.resolve_type(:flags)).to be_a(Yarrow::Schema::Types::Map)
    expect(type_container.resolve_type(:flags).key_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(:flags).key_type.unit).to be(Symbol)
    expect(type_container.resolve_type(:flags).value_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(:flags).value_type.unit).to be(SettingFlag)
  end

  specify :compound_map_with_custom_keys do
    Yarrow::Schema::Definitions.register(:lookup, Yarrow::Schema::Types::Map.of(Integer => String))

    expect(type_container.resolve_type(:lookup)).to be_a(Yarrow::Schema::Types::Map)
    expect(type_container.resolve_type(:lookup).key_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(:lookup).key_type.unit).to be(Integer)
    expect(type_container.resolve_type(:lookup).value_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(:lookup).value_type.unit).to be(String)
  end

  specify :compound_map_with_runtime_template_value do
    expect(type_container.resolve_type(map: :string)).to be_a(Yarrow::Schema::Types::Map)
    expect(type_container.resolve_type(map: :string).key_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(map: :string).key_type.unit).to be(Symbol)
    expect(type_container.resolve_type(map: :string).value_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(map: :string).value_type.unit).to be(String)
  end

  specify :compound_map_with_runtime_template_pair do
    expect(type_container.resolve_type(map: {integer: :string})).to be_a(Yarrow::Schema::Types::Map)
    expect(type_container.resolve_type(map: {integer: :string}).key_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(map: {integer: :string}).key_type.unit).to be(Integer)
    expect(type_container.resolve_type(map: {integer: :string}).value_type).to be_a(Yarrow::Schema::Types::Instance)
    expect(type_container.resolve_type(map: {integer: :string}).value_type.unit).to be(String)
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
