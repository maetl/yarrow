require 'date'

describe Yarrow::Process do
  specify 'connect compatible pipes' do
    class Step1 < Yarrow::Workflow::StepProcessor
      accepts DateTime
      provides String

      def step(timestamp)
        timestamp.iso8601
      end
    end

    class Step2 < Yarrow::Workflow::StepProcessor
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

    flow = Yarrow::Workflow::Pipeline.new(DateTime.new(2021, 2, 13))
    flow.connect(Step1.new)
    flow.connect(Step2.new)
    flow.process do |result|
      expect(result[:year]).to eq("2021")
      expect(result[:month]).to eq("02")
      expect(result[:day]).to eq("13")
    end
  end

  describe 'incompatible pipe errors' do
    class StrToInt < Yarrow::Workflow::StepProcessor
      accepts String
      provides Integer
    end

    class StrAcceptor < Yarrow::Workflow::StepProcessor
      accepts String
      provides String
    end

    it '`StrAcceptor` accepts `String` but was connected to `Integer`' do |spec|
      flow = Yarrow::Workflow::Pipeline.new("SOURCE")
      flow.connect(StrToInt.new)
      expect {
        flow.connect(StrAcceptor.new)
      }.to raise_error(ArgumentError, spec.description)
    end

    it '`StrToInt` accepts `String` but was connected to `Hash`' do |spec|
      flow = Yarrow::Workflow::Pipeline.new(Hash.new)
      expect {
        flow.connect(StrToInt.new)
      }.to raise_error(ArgumentError, spec.description)
    end
  end
end
