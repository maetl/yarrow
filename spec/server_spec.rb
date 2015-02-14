require 'spec_helper'

describe Yarrow::Server do
  include Rack::Test::Methods

  let(:app) { Yarrow::Server.app }

  it 'serves text files from pwd' do
    get '/LICENSE'
    expect(last_response).to be_ok
    expect(last_response.content_type).to include('text/plain')
    expect(last_response.body).to include('THE SOFTWARE')
  end

  it 'serves a directory index from pwd' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.content_type).to include('text/html')
    expect(last_response.body).to include('.mtime { text-align:right; }')
  end

end
