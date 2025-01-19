describe 'tee junction pipeline output' do
  let :junction_class do
    Yarrow::Process::Junction[Integer, Integer]
  end

  let :pipeline_int_to_str_instance do
    pipeline = Yarrow::Process::Pipeline.new(Integer)
    pipeline.connect(Yarrow::Process::Filter[Integer, String].new { |i| i.to_s })
    pipeline.connect(Yarrow::Process::Filter[String, String].new { |i| "$#{i}" })
    pipeline
  end

  let :filter_int_squared_instance do
    Yarrow::Process::Filter[Integer, Integer].new { |i| i * i }
  end

  let :junction_instance do
    junction_class.new(
      pipeline_int_to_str_instance
    )
  end

  specify 'run a branch pipeline from a junction' do
    result = junction_instance.run(4)

    expect(result.value).to eq(4)
    expect(result.children.first.value).to eq("$4")
  end

  specify 'embed a junction in a pipeline' do
    pipeline = Yarrow::Process::Pipeline.new(Integer)
    pipeline.connect(filter_int_squared_instance)
    pipeline.connect(junction_instance)
    pipeline.connect(filter_int_squared_instance)

    puts "junction spec"
    result = pipeline.run(4)
        
    p result

    expect(result.value).to eq(256)
    expect(result.children.first.value).to eq("$16")
  end

  specify 'junction provides output connection' do
    expect(junction_instance.can_connect?).to eq(true)
  end
end