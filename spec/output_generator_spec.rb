require "spec_helper"

describe Yarrow::Output::Generator do

  it "accepts configured object map" do

    config = Hashie::Mash.new({
      :output => {
        :object_map => {
          :index => :index,
          :pages => [:one, :two, :three]
        }
      }
    })

    generator = Yarrow::Output::Generator.new(config)
    expect(generator.object_map).to eq(config.output.object_map) 
  end

end
