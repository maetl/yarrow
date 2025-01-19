require 'spec_helper'
require 'date'

describe Yarrow::Process do
  specify 'identity result with no pipes connected' do
    flow = Yarrow::Process::Pipeline.new(Symbol)
    
    result = flow.run(:result)
    
    expect(result.value).to eq(:result)
  end

  specify 'filtered result' do
    class SymToStr < Yarrow::Process::Filter
      accept Symbol
      provide String

      def filter(input)
        input.to_s
      end
    end

    flow = Yarrow::Process::Pipeline.new(Symbol)
    flow.connect(SymToStr.new)

    result = flow.run(:result)

    expect(result.value).to eq('result')
  end

  specify 'connect filter chain' do
    class Step1 < Yarrow::Process::Filter
      accept DateTime
      provide String

      def filter(timestamp)
        timestamp.iso8601
      end
    end

    class Step2 < Yarrow::Process::Filter
      accept String
      provide Hash

      def filter(date)
        _year, _month, _day = date.split("T").first.split("-")
        {
          year: _year,
          month: _month,
          day: _day
        }
      end
    end

    flow = Yarrow::Process::Pipeline.new(DateTime)
    flow.connect(Step1.new)
    flow.connect(Step2.new)

    result = flow.run(DateTime.new(2021, 2, 13))

    expect(result.value[:year]).to eq("2021")
    expect(result.value[:month]).to eq("02")
    expect(result.value[:day]).to eq("13")
  end

  describe 'incompatible accept type errors' do
    class StrToInt < Yarrow::Process::Pipe
      accept String
      provide Integer
    end

    class StrAcceptor < Yarrow::Process::Pipe
      accept String
      provide String
    end

    it '`StrAcceptor` accepts `String` but was provided `Integer`' do |spec|
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToInt.new)
      expect {
        flow.connect(StrAcceptor.new)
      }.to raise_error(ArgumentError, spec.description)
    end

    it '`StrToInt` accepts `String` but was provided `Hash`' do |spec|
      flow = Yarrow::Process::Pipeline.new(Hash)
      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, spec.description)
    end
  end

  class StrToUpper < Yarrow::Process::Filter
    accept String
    provide String

    def filter(input)
      input.upcase
    end
  end

  class StrDup < Yarrow::Process::Filter
    accept String
    provide String

    def filter(input)
      input + input
    end
  end

  class StrRev < Yarrow::Process::Filter
    accept String
    provide String

    def filter(input)
      input.reverse
    end
  end

  describe 'split conduits' do
    it 'can split from single pipe' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.connect(StrDup.new)
        flow2.connect(StrRev.new)
      end

      result = flow.run("abc")

      expect(result.children.first.value).to eq('ABCABC')
      expect(result.children.last.value).to eq('CBA')
    end

    it 'result value is unchanged after split' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.connect(StrRev.new)
        flow2.connect(StrRev.new)
      end

      result = flow.run('bbz')

      expect(result.value).to eq('BBZ')
      expect(result.children.first.value).to eq('ZBB')
      expect(result.children.last.value).to eq('ZBB')
    end

    specify 'connect cannot be used inside split block' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.connect(StrRev.new)
        flow2.connect(StrDup.new)

        expect {
          flow.connect(StrToInt.new)
        }.to raise_error(ArgumentError, 'Cannot connect after split into child pipelines')
      end
    end

    specify 'connect cannot be used after split' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.connect(StrRev.new)
        flow2.connect(StrDup.new)
      end

      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, 'Cannot connect after split into child pipelines')
    end
  end

  describe 'manifold conduits' do
    it 'branches into multiple output flows at a manifold' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)

      flow.manifold(3) do |flows|
        flows[0].connect(StrDup.new)
        flows[1].connect(StrRev.new)
        flows[2].connect(StrRev.new)
        flows[2].connect(StrDup.new)
      end

      result = flow.run('ijk')

      expect(result.children[0].value).to eq('IJKIJK')
      expect(result.children[1].value).to eq('KJI')
      expect(result.children[2].value).to eq('KJIKJI')
    end

    specify 'connect cannot be used after manifold' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)

      flow.manifold(4) do |flows|
        flows[0].connect(StrDup.new)
        flows[1].connect(StrRev.new)
        flows[2].connect(StrRev.new)
        flows[3].connect(StrDup.new)
      end

      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, 'Cannot connect after split into child pipelines')
    end
  end

  describe 'tee junction' do
    it 'branches with a single outlet and rejoins the main conduit' do
      flow = Yarrow::Process::Pipeline.new(String)
      flow.connect(StrToUpper.new)
      

      flow.tee do |flow1|
        flow1.connect(StrDup.new)
      end

      flow.connect(StrRev.new)

      result = flow.run('xyz')

      expect(result.value).to eq('ZYX')
      expect(result.children.first.value).to eq("XYZXYZ")
    end
  end
end
