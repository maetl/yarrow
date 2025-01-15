require 'spec_helper'
require 'date'

describe Yarrow::Process do
  specify 'on_complete callback on empty run' do
    token = :result
    flow = Yarrow::Process::Workflow.new(Symbol)
    flow.on_complete do |result|
      expect(result).to be(token)
    end

    flow.run(token)
  end

  specify 'on_complete callback on identity filter' do
    class SymToStr < Yarrow::Process::Task
      accepts Symbol
      provides String

      def step(result)
        result.to_s
      end
    end

    flow = Yarrow::Process::Workflow.new(Symbol)
    flow.connect(SymToStr.new)
    flow.on_complete do |result|
      expect(result).to eq('result')
    end

    flow.run(:result)
  end

  specify 'connect filter chain' do
    class Step1 < Yarrow::Process::Task
      accepts DateTime
      provides String

      def step(timestamp)
        timestamp.iso8601
      end
    end

    class Step2 < Yarrow::Process::Task
      accepts String
      provides Hash

      def step(date)
        _year, _month, _day = date.split("T").first.split("-")
        {
          year: _year,
          month: _month,
          day: _day
        }
      end
    end

    flow = Yarrow::Process::Workflow.new(DateTime)
    flow.connect(Step1.new)
    flow.connect(Step2.new)
    
    flow.on_complete do |result|
      expect(result[:year]).to eq("2021")
      expect(result[:month]).to eq("02")
      expect(result[:day]).to eq("13")
    end

    flow.run(DateTime.new(2021, 2, 13))
  end

  describe 'incompatible accept type errors' do
    class StrToInt < Yarrow::Process::Task
      accepts String
      provides Integer
    end

    class StrAcceptor < Yarrow::Process::Task
      accepts String
      provides String
    end

    it '`StrAcceptor` accepts `String` but was provided `Integer`' do |spec|
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToInt.new)
      expect {
        flow.connect(StrAcceptor.new)
      }.to raise_error(ArgumentError, spec.description)
    end

    it '`StrToInt` accepts `String` but was provided `Hash`' do |spec|
      flow = Yarrow::Process::Workflow.new(Hash)
      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, spec.description)
    end
  end

  class StrToUpper < Yarrow::Process::Task
    accepts String
    provides String

    def step(input)
      input.upcase
    end
  end

  class StrDup < Yarrow::Process::Task
    accepts String
    provides String

    def step(input)
      input + input
    end
  end

  class StrRev < Yarrow::Process::Task
    accepts String
    provides String

    def step(input)
      input.reverse
    end
  end

  describe 'split conduits' do
    it 'can split from single pipe' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.connect(StrDup.new)
        flow1.on_complete do |result|
          expect(result).to eq('ABCABC')
        end

        flow2.connect(StrRev.new)
        flow2.on_complete do |result|
          expect(result).to eq('CBA')
        end
      end

      flow.run("abc")
    end

    it 'on_complete result is undefined after split' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.on_complete do |result1|
          expect(result1).to eq("BBZ")
        end

        flow2.on_complete do |result2|
          expect(result2).to eq("BBZ")
        end
      end

      flow.on_complete do |result|
        expect(result).to be(nil)
      end

      flow.run("bbz")
    end

    specify 'connect cannot be used inside split block' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.on_complete do |result1|
          return
        end

        flow2.on_complete do |result2|
          return
        end

        expect {
          flow.connect(StrToInt.new)
        }.to raise_error(ArgumentError, 'Cannot connect tasks at this level after workflow is split')
      end
    end

    specify 'connect cannot be used after split' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)

      flow.split do |flow1, flow2|
        flow1.on_complete do |result1|
          return
        end

        flow2.on_complete do |result2|
          return
        end
      end

      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, 'Cannot connect tasks at this level after workflow is split')
    end
  end

  describe 'manifold conduits' do
    it 'branches into multiple output flows at a manifold' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)

      flow.manifold(3) do |flows|
        flows[0].connect(StrDup.new)
        flows[0].on_complete do |result|
          expect(result).to eq('IJKIJK')
        end

        flows[1].connect(StrRev.new)
        flows[1].on_complete do |result|
          expect(result).to eq('KJI')
        end

        flows[2].connect(StrRev.new)
        flows[2].connect(StrDup.new)
        flows[2].on_complete do |result|
          expect(result).to eq('KJIKJI')
        end
      end

      flow.run('ijk')
    end

    specify 'connect cannot be used after manifold' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)

      flow.manifold(4) do |flows|
        flows[0].on_complete do |result1|
          return
        end

        flows[1].on_complete do |result2|
          return
        end

        flows[2].on_complete do |result2|
          return
        end

        flows[3].on_complete do |result2|
          return
        end
      end

      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, 'Cannot connect tasks at this level after workflow is split')
    end
  end

  describe 'tee junction' do
    it 'branches with a single outlet and rejoins the main conduit' do
      flow = Yarrow::Process::Workflow.new(String)
      flow.connect(StrToUpper.new)
      flow.connect(StrRev.new)

      strcon = Yarrow::Process::Task[String, Symbol]

      i_strcon = strcon.new
      puts i_strcon.accepts
      puts i_strcon.provides

      class TestOne < Yarrow::Process::Task
        accepts Integer
        provides DateTime
      end

      i_testone = TestOne.new
      puts i_testone.accepts
      puts i_testone.provides

      i_branch = Yarrow::Process::Task[Struct].new

      puts i_branch.accepts
      puts i_branch.provides

      # flow.tee do |flow1|
      #   flow1.connect(StrDup.new)
      #   flow1.on_complete do |result|
      #     expect(result).to eq('ZYXZYX')
      #   end
      # end

      # p flow

      # flow.connect(StrRev.new)

      # flow.on_complete do |result|
      #   expect(result).to eq("XYZ")
      # end

      # flow.run('xyz')
    end
  end
end
