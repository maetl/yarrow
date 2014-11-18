require "spec_helper"

describe Yarrow::Model::Index do

  class NewModelClass < Yarrow::Model::Base
    attribute :id, String
  end

  it "registers collection methods from extensions of Model::Base" do
    expect(Yarrow::Model::Index.respond_to?(:new_model_classes)).to eq(true)
  end

  it "provides an enumerable relation over the collection" do
    expect(Yarrow::Model::Index.new_model_classes).to be_instance_of(Array)
  end

end
