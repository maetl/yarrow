describe "indexed file" do
  let(:output_dir) do
    Pathname.new(File.expand_path(ENV["TMPDIR"] + "/docroot"))
  end

  let(:raw_fixture) do
    Yarrow::Config::Instance.new(
      output: output_dir,
      source: "~~does not matter~~",
      content: "~~does not matter~~"
    )
  end

  it "writes permalinks with trailing slashes to standard index" do
    puts raw_fixture
    #writer = Yarrow::Output::Web::IndexedFile.new(io_obj, output_dir)
    #writer.write(Pathname.new("/collection/topic/"), "<h1>Index</h1>")
  end
end
