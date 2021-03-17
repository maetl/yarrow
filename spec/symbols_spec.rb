describe Yarrow::Symbols do
  BlittyBlob = [:bits, :len]
  GliffyFlip = [:gif, :jif]

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
end
