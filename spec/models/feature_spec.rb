require 'rails_helper'

RSpec.describe Feature, type: :model do
  it "is valid with name and enabled state" do
    feature = Feature.new(name: "chat", enabled: true)
    expect(feature).to be_valid
  end

  it "is invalid without a name" do
    feature = Feature.new(enabled: true)
    expect(feature).not_to be_valid
  end

  it "does not allow duplicate names" do
    Feature.create!(name: "chat", enabled: true)
    feature2 = Feature.new(name: "chat", enabled: false)
    expect(feature2).not_to be_valid
  end

  it "has many feature_overrides" do
    assoc = Feature.reflect_on_association(:feature_overrides)
    expect(assoc.macro).to eq(:has_many)
  end
end
