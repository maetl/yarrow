describe Yarrow::Symbols do
  BlittyBlob = [:bits, :len]
  GliffyFlip = [:gif, :jif]
  Jittery = Class.new
  module SpliTty; class Blit; Z = :z; end; end
  module One; module Two; module Three; class Four; FOUR = 4; end; end; end; end

  it "converts a string module path to a live constant" do
    splitty_bit = Yarrow::Symbols.to_module_const(["SpliTty", "Blit"])
    expect(splitty_bit).to be(SpliTty::Blit)
    expect(splitty_bit::Z).to eq(:z)
  end

  it "converts a symbol module path to a live constant" do
    splitty_bit = Yarrow::Symbols.to_module_const([:spli_tty, :blit])
    expect(splitty_bit).to be(SpliTty::Blit)
    expect(splitty_bit::Z).to eq(:z)
  end

  it "converts a sequence of nested module strings to a live constant" do
    four = Yarrow::Symbols.to_module_const("One::Two::Three::Four".split("::"))
    expect(four).to be(One::Two::Three::Four)
    expect(four::FOUR).to eq(4)
  end

  it "converts an underscored noun symbol to a live constant" do
    blitty_blob = Yarrow::Symbols.to_const(:blitty_blob)
    expect(blitty_blob.first).to eq(:bits)
    expect(blitty_blob.last).to eq(:len)
  end

  it "converts a munged string to a live constant" do
    gliffy_flip = Yarrow::Symbols.to_const("gliffy FLIP")
    expect(gliffy_flip.first).to eq(:gif)
    expect(gliffy_flip.last).to eq(:jif)
  end

  it "converts a string constant name to a symbol atom" do
    expect(Yarrow::Symbols.from_const("AtomicSymbol")).to eq(:atomic_symbol)
    expect(Yarrow::Symbols.from_const("Pages")).to eq(:pages)
    expect(Yarrow::Symbols.from_const("Yarrow::Symbols")).to eq(:yarrow_symbols)
  end

  it "converts a class constant name to a symbol atom" do
    expect(Yarrow::Symbols.from_const(:BlittyBlob)).to eq(:blitty_blob)
    expect(Yarrow::Symbols.from_const(Jittery)).to eq(:jittery)
    expect(Yarrow::Symbols.from_const(Yarrow)).to eq(:yarrow)
    expect(Yarrow::Symbols.from_const(Yarrow::Symbols)).to eq(:yarrow_symbols)
  end

  it "converts singular noun symbols to a plural form" do
    expect(Yarrow::Symbols.to_plural(:page)).to eq(:pages)
    expect(Yarrow::Symbols.to_plural(:entry)).to eq(:entries)
    expect(Yarrow::Symbols.to_plural(:index)).to eq(:indices)
    expect(Yarrow::Symbols.to_plural(:post)).to eq(:posts)
  end

  it "converts plural noun symbols to a singular form" do
    expect(Yarrow::Symbols.to_singular(:pages)).to eq(:page)
    expect(Yarrow::Symbols.to_singular(:entries)).to eq(:entry)
    expect(Yarrow::Symbols.to_singular(:indexes)).to eq(:index)
    expect(Yarrow::Symbols.to_singular(:indices)).to eq(:index)
    expect(Yarrow::Symbols.to_singular(:posts)).to eq(:post)
  end

  it "converts symbol identifiers to readable text" do
    expect(Yarrow::Symbols.to_text(:on_node_visited)).to eq("On node visited")
    expect(Yarrow::Symbols.to_text(:pages)).to eq("Pages")
  end

  it "converts string identifiers to readable text" do
    expect(Yarrow::Symbols.to_text("on-node-visited")).to eq("On node visited")
    expect(Yarrow::Symbols.to_text("on--node--visited")).to eq("On node visited")
    expect(Yarrow::Symbols.to_text("on-_-node-_-visited")).to eq("On node visited")
    expect(Yarrow::Symbols.to_text("_on-button-clicked")).to eq("On button clicked")
    expect(Yarrow::Symbols.to_text("--on-button-clicked")).to eq("On button clicked")
    expect(Yarrow::Symbols.to_text("_-_on-button-clicked")).to eq("On button clicked")
  end
end
