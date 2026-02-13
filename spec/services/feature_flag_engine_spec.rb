require 'rails_helper'

RSpec.describe FeatureFlagEngine do
  let!(:group) { Group.create!(name: "Testers") }
  let!(:user)  { User.create!(name: "Ameen", group: group) }
  let!(:feature) { Feature.create!(name: "chat_feature", enabled: false, description: "Test feature") }

  describe ".enabled?" do
    it "returns global default when no overrides" do
      expect(FeatureFlagEngine.enabled?(:chat_feature)).to eq(false)
    end

    it "returns user override if present" do
      FeatureOverride.create!(feature: feature, user_id: user.id, enabled: true)
      expect(FeatureFlagEngine.enabled?(:chat_feature, user)).to eq(true)
    end

    it "returns group override if no user override" do
      FeatureOverride.create!(feature: feature, group_id: group.id, enabled: true)
      expect(FeatureFlagEngine.enabled?(:chat_feature, user)).to eq(true)
    end

    it "returns region override if present" do
      FeatureOverride.create!(feature: feature, region: "US", enabled: true)
      expect(FeatureFlagEngine.enabled?(:chat_feature, nil, region: "US")).to eq(true)
    end

    it "region override works even if user exists with no user/group override" do
      FeatureOverride.create!(feature: feature, region: "EU", enabled: true)
      user_no_override = User.create!(name: "NoOverride")
      expect(FeatureFlagEngine.enabled?(:chat_feature, user_no_override, region: "EU")).to eq(true)
    end

    it "handles user without group" do
      user_no_group = User.create!(name: "NoGroup")
      expect(FeatureFlagEngine.enabled?(:chat_feature, user_no_group)).to eq(false)
    end

    it "clears cache" do
      FeatureFlagEngine.enabled?(:chat_feature)
      expect(FeatureFlagEngine.instance_variable_get(:@cache)).not_to be_empty
      FeatureFlagEngine.clear_cache!
      expect(FeatureFlagEngine.instance_variable_get(:@cache)).to be_empty
    end

    it "raises error if feature not found" do
      expect { FeatureFlagEngine.enabled?(:nonexistent) }.to raise_error("Feature not found")
    end
  end
end
