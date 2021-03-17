describe "indexed file" do
  let(:output_path) do
    Pathname.new(File.expand_path("#{ENV['TMPDIR']}/docroot"))
  end

  let(:raw_fixture) do
    Yarrow::Config::Instance.new(
      output_dir: output_path,
      source: Pathname.new("~~does not matter~~"),
      content: Pathname.new("~~does not matter~~")
    )
  end

  it "writes permalinks with trailing slashes to standard index" do
    expect(raw_fixture.output_dir).to eq(output_path)
    #writer = Yarrow::Output::Web::IndexedFile.new(io_obj, output_dir)
    #writer.write(Pathname.new("/collection/topic/"), "<h1>Index</h1>")
  end
end
