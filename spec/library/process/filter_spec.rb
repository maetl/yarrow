describe 'dynamic constructor with block given' do
  let :filter_class do
    Yarrow::Process::Filter[String, Symbol]
  end

  let :filter_instance do
    filter_class.new do |input|
      input.gsub(/\s/, '_').to_sym
    end
  end

  specify 'run filter' do
    result = filter_instance.run("pipe and filter")

    expect(result.value).to eq(:pipe_and_filter)
    expect(result.children.any?).to eq(false)
  end
end

describe 'instance constructor with inherited filter method' do
  class FilterUnderscoreSymbol < Yarrow::Process::Filter
    accept String
    provide Symbol

    def filter(input)
      input.gsub(/\s/, '_').to_sym
    end
  end

  let :filter_instance do
    FilterUnderscoreSymbol.new
  end

  specify 'run filter' do
    result = filter_instance.run("pipe and filter")

    expect(result.value).to eq(:pipe_and_filter)
    expect(result.children.any?).to eq(false)
  end
end