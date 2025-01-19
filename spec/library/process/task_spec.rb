require 'spec_helper'

describe 'dynamic constructor' do
  let :pipe_class do
    Yarrow::Process::Pipe[String, Symbol]
  end

  let :pipe_instance do
    pipe_class.new
  end

  specify 'type check readers' do
    expect(pipe_instance.accepts).to eq(:String)
    expect(pipe_instance.provides).to eq(:Symbol)
  end

  specify 'can_accept? predicate with class const' do
    expect(pipe_instance.can_accept?(Integer)).to eql(false)
    expect(pipe_instance.can_accept?(Symbol)).to eql(false)
    expect(pipe_instance.can_accept?(String)).to eql(true)
  end

  specify 'can_accept? predicate with symbol' do
    expect(pipe_instance.can_accept?(:Integer)).to eql(false)
    expect(pipe_instance.can_accept?(:Symbol)).to eql(false)
    expect(pipe_instance.can_accept?(:String)).to eql(true)
  end

  specify 'can_connect? predicate' do
    expect(pipe_instance.can_connect?).to eql(true)
  end
end

describe 'inheritance constructor' do
  class PipeStringToSymbol < Yarrow::Process::Pipe
    accept String
    provide Symbol
  end

  let :pipe_instance do
    PipeStringToSymbol.new
  end

  specify 'type check readers' do
    expect(pipe_instance.accepts).to eq(:String)
    expect(pipe_instance.provides).to eq(:Symbol)
  end

  specify 'can_connect? predicate' do
    expect(pipe_instance.can_connect?).to eql(true)
  end
end

describe 'dynamic constructor without provided type given' do
  let :pipe_class do
    Yarrow::Process::Pipe[Symbol]
  end

  let :pipe_instance do
    pipe_class.new
  end

  specify 'type check readers' do
    expect(pipe_instance.accepts).to eq(:Symbol)
    expect(pipe_instance.provides).to eq(nil)
  end

  specify 'can_connect? predicate' do
    expect(pipe_instance.can_connect?).to eql(false)
  end
end
