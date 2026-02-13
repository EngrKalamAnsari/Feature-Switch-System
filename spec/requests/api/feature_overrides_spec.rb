require 'rails_helper'

RSpec.describe "Api::FeatureOverrides", type: :request do
  let!(:group) { Group.create!(name: "Testers") }
  let!(:user) { User.create!(name: "Test", group: group) }
  let!(:feature) { Feature.create!(name: "chat_feature", enabled: false) }

  let!(:override_record) do
    feature.feature_overrides.create!(
      enabled: true,
      user_id: user.id
    )
  end

  describe "POST /create" do
    it "creates override" do
      post api_feature_flag_overrides_path(feature),
           params: { override: { enabled: true, user_id: user.id } }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:created)
      expect(json["success"]).to eq(true)
    end
  end

  describe "PATCH /update" do
    it "updates override" do
      patch api_feature_flag_override_path(feature, override_record),
            params: { override: { enabled: false } }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["data"]["enabled"]).to eq(false)
    end
  end

  describe "DELETE /destroy" do
    it "deletes override" do
      delete api_feature_flag_override_path(feature, override_record)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["success"]).to eq(true)
    end
  end
end
