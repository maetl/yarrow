require 'spec_helper'

$fake_path = Pathname.new("~/fake-path")

describe Yarrow::Server do
  include Rack::Test::Methods

  context 'Server configuration is missing' do
    class MisconfiguredServer < Yarrow::Server
      def initialize
        super(Yarrow::Config::Instance.new(
          output_dir: $fake_path,
          content: $fake_path,
          source: $fake_path
        ))
      end
    end

    it 'raises configuration error' do
      expect {
        MisconfiguredServer.new
      }.to raise_error(Yarrow::ConfigurationError)
    end
  end

  context 'Serves current working directory' do
    class PwdServer < Yarrow::Server
      def initialize
        super(Yarrow::Config::Instance.new(
          output_dir: Pathname.new(File.expand_path(".")),
          content: $fake_path,
          source: $fake_path,
          server: Yarrow::Config::Server.new(
            port: 8888,
            host: 'localhost',
            handler: :thin
          )
        ))
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
      def initialize
        super(Yarrow::Config::Instance.new(
          output_dir: Pathname.new("spec/fixtures/server/directory"),
          content: $fake_path,
          source: $fake_path,
          server: Yarrow::Config::Server.new(
            port: 8888,
            host: 'localhost',
            handler: :thin
          )
        ))
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

  context 'Serves index files as directory indexes' do

    class DirectoryIndexServer < Yarrow::Server
      def initialize
        super(Yarrow::Config::Instance.new(
          output_dir: Pathname.new("spec/fixtures/server/index"),
          content: $fake_path,
          source: $fake_path,
          server: Yarrow::Config::Server.new(
            port: 8888,
            host: 'localhost',
            handler: :thin
          )
        ))
      end
    end

    let(:app) { DirectoryIndexServer.new.app }

    it 'serves index file from root' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('<h1>/</h1>')
    end

    it 'serves index file from nested path' do
      get '/nested/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('<h1>/nested/</h1>')
    end
  end

  context "Serves text/html files without explicit extensions" do
    class ExtensionlessServer < Yarrow::Server
      def initialize
        super(Yarrow::Config::Instance.new(
          output_dir: Pathname.new("spec/fixtures/server/extensionless"),
          content: $fake_path,
          source: $fake_path,
          server: Yarrow::Config::Server.new(
            port: 8888,
            host: 'localhost',
            handler: :thin,
            auto_index: false,
            default_index: 'index',
            default_type: 'text/html'
          )
        ))
      end
    end

    let(:app) { ExtensionlessServer.new.app }

    it 'serves index file without an extension' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('<h1>extensionless/index</h1>')
    end

    it 'serves plain file without an extension' do
      get '/home'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('text/html')
      expect(last_response.body).to include('<h1>extensionless/home</h1>')
    end
  end
end
