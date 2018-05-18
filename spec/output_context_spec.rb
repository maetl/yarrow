require "spec_helper"

describe Yarrow::Output::Context do
  let(:context_hash) do
    Yarrow::Output::Context.new(number: 99, text: "plain value")
  end

  class Value
    def text
      "nested value"
    end
  end

  let(:object_hash) do
    Yarrow::Output::Context.new(value: Value.new)
  end

  it 'generates dynamic accessors for hash values on initialization' do
    expect(context_hash.number).to eq(99)
    expect(context_hash.text).to eq("plain value")
  end

  it 'generates dynamic accessors for value objects on initialization' do
    expect(object_hash.value.text).to eq("nested value")
  end
end
