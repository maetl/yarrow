describe Yarrow::Schema::Type do
  describe Yarrow::Schema::Type::Raw do
    it "delegates to wrapped type in the constructor" do
      Atom = Class.new
      type_class = Yarrow::Schema::Type::Raw[Atom]

      expect(type_class).to be_a(Atom.class)
    end
  end
end
