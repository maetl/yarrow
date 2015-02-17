require 'spec_helper'

describe Yarrow::Server do
  include Rack::Test::Methods

  context 'Serves current working directory when config is empty' do

    class PwdServer < Yarrow::Server
      def config
        Yarrow::Configuration.new
      end
    end

    let(:app) { PwdServer.new.app }

    it 'serves files' do
      get '/LICENSE'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/plain')
      expect(last_response.body).to include('THE SOFTWARE')
    end

    it 'serves a directory index' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('.mtime { text-align:right; }')
    end

  end

  context 'Serves directory specified in config' do

    class DirectoryServer < Yarrow::Server
      def config
        Yarrow::Configuration.new(output_dir: 'spec/fixtures/server/directory')
      end
    end

    let(:app) { DirectoryServer.new.app }

    it 'serves files' do
      get '/file.html'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('<p>file.html</p>')
    end

    it 'serves a directory index' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('.mtime { text-align:right; }')
    end

  end

end
