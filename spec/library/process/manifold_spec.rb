describe 'nested pipeline output' do
  let :manifold_class do
    Yarrow::Process::Manifold[String]
  end

  let :pipeline_int_to_str_instance do
    pipeline = Yarrow::Process::Pipeline.new(Integer)
    pipeline.connect(Yarrow::Process::Filter[Integer, String].new { |i| i.to_s })
    pipeline.connect(Yarrow::Process::Filter[String, String].new { |i| "$#{i}" })
    pipeline
  end

  let :pipeline_int_squared_instance do
    pipeline = Yarrow::Process::Pipeline.new(Integer)
    pipeline.connect(Yarrow::Process::Filter[Integer, Integer].new { |i| i * i })
    pipeline
  end

  let :manifold_instance do
    manifold_class.new(
      pipeline_int_to_str_instance,
      pipeline_int_squared_instance
    )
  end

  specify 'run multiple pipelines through manifold' do
    result = manifold_instance.run(4)
    expect(result.value).to eq(4)
    expect(result.children.first.value).to eq('$4')
    expect(result.children.last.value).to eq(16)
  end

  specify 'manifold does not provide output connection' do
    expect(manifold_instance.can_connect?).to eq(false)
  end
end