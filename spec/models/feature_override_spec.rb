require 'rails_helper'

RSpec.describe FeatureOverride, type: :model do
  let!(:feature) { Feature.create!(name: "chat_feature", enabled: false) }

  it "is valid with a feature and enabled value" do
    override = FeatureOverride.new(feature: feature, enabled: true)
    expect(override).to be_valid
  end

  it "is invalid without enabled value" do
    override = FeatureOverride.new(feature: feature)
    expect(override).not_to be_valid
  end
end
