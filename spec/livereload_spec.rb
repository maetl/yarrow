require 'spec_helper'

describe Yarrow::Server::Livereload::Reactor do
  it 'starts and stops' do
    reactor = Yarrow::Server::Livereload::Reactor.new
    expect(reactor.running?).to be false
    reactor.start
    expect(reactor.running?).to be true
    reactor.stop
    expect(reactor.running?).to be false
  end
end
