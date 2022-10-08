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
        Yarrow::Schema::Types::Instance.new(String)
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
        Yarrow::Schema::Types::Instance.new(Integer)
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
  end
end
