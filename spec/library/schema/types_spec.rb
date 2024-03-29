require "spec_helper"

describe Yarrow::Schema::Types do
  describe Yarrow::Schema::Types::TypeClass do
    specify :unit do
      type_class = Yarrow::Schema::Types::TypeClass.new(Object)
      expect(type_class.unit).to eq(Object)
    end

    specify :check_instance_of! do
      type_class = Yarrow::Schema::Types::TypeClass.new(Object)
      expect { type_class.check_instance_of!(Object.new) }.not_to raise_error
      expect { type_class.check_instance_of!(Class.new) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "Class is not an instance of Object"
      )
    end

    specify :check_kind_of! do
      type_class = Yarrow::Schema::Types::TypeClass.new(Numeric)
      expect { type_class.check_kind_of!(1234) }.not_to raise_error
      expect { type_class.check_kind_of!("") }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "String is not a subclass of Numeric"
      )
    end

    let :member_methods do
      [:to_jank, :to_glitch]
    end

    class Jank
      def to_jank
        :jank
      end

      def to_glitch
        :glitch
      end
    end

    class Glitch
      def to_glitch
        :glitch
      end
    end

    specify :check_respond_to_any! do
      type_class = Yarrow::Schema::Types::TypeClass.new
      expect { type_class.check_respond_to_any!(Jank.new, member_methods) }.not_to raise_error
      expect { type_class.check_respond_to_any!(Glitch.new, member_methods) }.not_to raise_error
      expect { type_class.check_respond_to_any!("", member_methods) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "String does not implement any of [:to_jank, :to_glitch]"
      )
    end

    specify :check_respond_to_all! do
      type_class = Yarrow::Schema::Types::TypeClass.new
      expect { type_class.check_respond_to_all!(Jank.new, member_methods) }.not_to raise_error
      expect { type_class.check_respond_to_all!(Glitch.new, member_methods) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "Glitch does not implement [:to_jank, :to_glitch]"
      )
    end
  end

  describe Yarrow::Schema::Types::Any do
    let :any_type do
      Yarrow::Schema::Types::Any.new
    end

    specify :cast do
      expect(any_type.cast("hello")).to eq("hello")
      expect(any_type.cast("")).to eq("")
      expect(any_type.cast(1234)).to eq(1234)
      expect(any_type.cast(:abcd)).to eq(:abcd)
      expect(any_type.cast({:a => "A"})).to eq({:a => "A"})
    end
  end

  describe Yarrow::Schema::Types::Instance do
    describe :string do
      let :string_type do
        Yarrow::Schema::Types::Instance.of(String)
      end

      specify :cast do
        expect(string_type.cast("hello")).to eq("hello")
        expect(string_type.cast("")).to eq("")
        expect{ string_type.cast(1234) }.to raise_error(
          Yarrow::Schema::Types::CastError,
          "Integer is not an instance of String"
        )
        expect{ string_type.cast(:abcd) }.to raise_error(
          Yarrow::Schema::Types::CastError,
          "Symbol is not an instance of String"
        )
      end
    end

    describe :integer do
      let :int_type do
        Yarrow::Schema::Types::Instance.of(Integer)
      end

      specify :cast do
        expect(int_type.cast(0)).to eq(0)
        expect(int_type.cast(1234)).to eq(1234)
        expect(int_type.cast(-1)).to eq(-1)
        expect{ int_type.cast("hello") }.to raise_error("String is not an instance of Integer")
        expect{ int_type.cast(:abcd) }.to raise_error("Symbol is not an instance of Integer")
        expect{ int_type.cast(4.34) }.to raise_error("Float is not an instance of Integer")
      end
    end

    describe :datetime do
      let :datetime_type do
        Yarrow::Schema::Types::Instance.of(DateTime).accept(String, :parse)
      end

      specify :cast do
        expect(datetime_type.cast(DateTime.new)).to be_a(DateTime)
        expect(datetime_type.cast("2022-10-10")).to be_a(DateTime)
        expect{ datetime_type.cast(2022) }.to raise_error("Integer is not an instance of DateTime")
      end
    end

    describe :string_scanner do
      let :string_scanner_type do
        Yarrow::Schema::Types::Instance.of(StringScanner).accept(String, :new, { fixed_anchor: true })
      end

      specify :cast do
        expect(string_scanner_type.cast(StringScanner.new(""))).to be_a(StringScanner)
        expect(string_scanner_type.cast("...")).to be_a(StringScanner)
        expect(string_scanner_type.cast("...").fixed_anchor?).to be(true)
        expect{ string_scanner_type.cast(2022) }.to raise_error("Integer is not an instance of StringScanner")
      end
    end
  end

  describe Yarrow::Schema::Types::Interface do
    describe :any do
      let :duck_type do
        Yarrow::Schema::Types::Interface.any(:to_duck, :to_quack)
      end

      class DuckWalker
        def to_duck
          :duck
        end
      end

      class DuckQuacker
        def to_quack
          :quack
        end
      end

      specify :cast do
        expect(duck_type.cast(DuckWalker.new)).to be_a(DuckWalker)
        expect(duck_type.cast(DuckQuacker.new)).to be_a(DuckQuacker)
        expect{ duck_type.cast("hello") }.to raise_error(
          Yarrow::Schema::Types::CastError,
          "String does not implement any of [:to_duck, :to_quack]"
        )
        expect{ duck_type.cast(1234) }.to raise_error(
          Yarrow::Schema::Types::CastError,
          "Integer does not implement any of [:to_duck, :to_quack]"
        )

      end
    end

    describe :all do
      let :thing_type do
        Yarrow::Schema::Types::Interface.all(:to_head, :to_body)
      end

      class ThingOne
        def to_head
          :head
        end

        def to_body
          :body
        end
      end

      class ThingTwo
        def to_head
          :head
        end

        def to_body
          :body
        end
      end

      specify :cast do
        expect(thing_type.cast(ThingOne.new)).to be_a(ThingOne)
        expect(thing_type.cast(ThingTwo.new)).to be_a(ThingTwo)
        expect{ thing_type.cast("hello") }.to raise_error(
          Yarrow::Schema::Types::CastError,
          "String does not implement [:to_head, :to_body]"
        )
        expect{ thing_type.cast(1234) }.to raise_error(
          Yarrow::Schema::Types::CastError,
          "Integer does not implement [:to_head, :to_body]"
        )
      end
    end
  end

  describe Yarrow::Schema::Types::List do
    let :list_type do
      Yarrow::Schema::Types::List.of(Float)
    end

    let :dynamic_list_type do
      Yarrow::Schema::Types::List.any
    end

    specify :cast do
      expect(list_type.cast([0.4, 0.3, 0.7])).to eq([0.4, 0.3, 0.7])

      expect{ list_type.cast([4, 3, 7])}.to raise_error(
        Yarrow::Schema::Types::CastError,
        "Integer is not an instance of Float"
      )
    end

    specify :dynamic_cast do
      expect(dynamic_list_type.cast([0.4, 0.3, 0.7])).to eq([0.4, 0.3, 0.7])
      expect(dynamic_list_type.cast(["aaa", "bbb"])).to eq(["aaa", "bbb"])
    end

    specify :bad_container do
      expect{ list_type.cast(100) }.to raise_error("Integer is not an instance of Array")
      expect{ dynamic_list_type.cast("abcd") }.to raise_error("String is not an instance of Array")
    end
  end

  describe Yarrow::Schema::Types::Map do
    specify :map_with_implicit_keys do
      map_type = Yarrow::Schema::Types::Map.of(Integer)

      expect(map_type.cast({a: 1, b: 2})).to eq({a: 1, b: 2})
      expect{ map_type.cast({a: "1", b: "2"}) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "String is not an instance of Integer"
      )
      expect{ map_type.cast({"a" => "1", "b" => "2"}) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "String is not an instance of Symbol"
      )
    end

    specify :map_of_hash_with_implicit_keys do
      map_type = Yarrow::Schema::Types::Map.of(Hash)

      expect(map_type.cast({a: {one: 1}, b: {two: 2}})).to eq({a: {one: 1}, b: {two: 2}})
      expect(map_type.cast({a: {}, b: {}})).to eq({a: {}, b: {}})
      expect(map_type.cast({a: {"1" => 1}, b: {"2" => 2}})).to eq({a: {"1" => 1}, b: {"2" => 2}})
    end

    specify :map_with_explicit_keys do
      map_type = Yarrow::Schema::Types::Map.of(String => Integer)

      expect(map_type.cast({"a" => 1, "b" => 2})).to eq({"a" => 1, "b" => 2})
      expect{ map_type.cast({"a" => "1", "b" => "2"}) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "String is not an instance of Integer"
      )
      expect{ map_type.cast({a: "1", b: "2"}) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "Symbol is not an instance of String"
      )
    end
  end

  describe Yarrow::Schema::Types::Union do
    specify "instance of membership in union of two types" do
      union_type = Yarrow::Schema::Types::Union.of(String, Integer)

      expect(union_type.cast("a1234")).to eq("a1234")
      expect(union_type.cast(1234)).to eq(1234)

      expect{ union_type.cast(:a1234) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "Symbol is not a member of union"
      )
    end

    specify "instance of membership in union of three types" do
      union_type = Yarrow::Schema::Types::Union.of(String, Integer, Symbol)

      expect(union_type.cast("a1234")).to eq("a1234")
      expect(union_type.cast(1234)).to eq(1234)
      expect(union_type.cast(:a1234)).to eq(:a1234)

      expect{ union_type.cast(nil) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "NilClass is not a member of union"
      )
    end

    specify "declare union type using operator overloading" do
      union_type = Yarrow::Schema::Types::Instance.of(String) | Yarrow::Schema::Types::Instance.of(Integer)

      expect(union_type.cast("a1234")).to eq("a1234")
      expect(union_type.cast(1234)).to eq(1234)

      expect{ union_type.cast(:a1234) }.to raise_error(
        Yarrow::Schema::Types::CastError,
        "Symbol is not a member of union"
      )
    end
  end
end
