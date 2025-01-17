require 'spec_helper'

describe 'define task with accept and provide types' do
  let :task_class do
    Yarrow::Process::Task[String, Symbol]
  end

  let :task_instance do
    task_class.new
  end

  specify 'type check readers' do
    expect(task_instance.accepts).to eq('String')
    expect(task_instance.provides).to eq('Symbol')
  end

  specify 'can_accept? predicate' do
    expect(task_instance.can_accept?(Integer)).to eql(false)
    expect(task_instance.can_accept?(Symbol)).to eql(false)
    expect(task_instance.can_accept?(String)).to eql(true)
  end

  specify 'can_connect? predicate' do
    expect(task_instance.can_connect?).to eql(true)
  end
end

describe 'define task with accept type without provide type' do
    let :task_class do
      Yarrow::Process::Task[Symbol]
    end
  
    let :task_instance do
      task_class.new([])
    end
  
    specify 'type check readers' do
      expect(task_instance.accepts).to eq('Symbol')
      expect(task_instance.provides).to eq(nil)
    end
  
    specify 'can_accept? predicate' do
      expect(task_instance.can_accept?(Integer)).to eql(false)
      expect(task_instance.can_accept?(String)).to eql(false)
      expect(task_instance.can_accept?(Symbol)).to eql(true)
    end
  
    specify 'can_connect? predicate' do
      expect(task_instance.can_connect?).to eql(false)
    end
  end