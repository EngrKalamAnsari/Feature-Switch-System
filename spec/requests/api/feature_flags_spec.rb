require 'rails_helper'

RSpec.describe "Api::FeatureFlags", type: :request do
  let!(:group) { Group.create!(name: "Testers") }
  let!(:user) { User.create!(name: "Ameen", group: group) }
  let!(:feature) { Feature.create!(name: "chat_feature", enabled: false, description: "Test feature") }

  describe "GET /index" do
    it "returns all features" do
      get api_feature_flags_path

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json).to be_a(Hash)
      expect(json["success"]).to eq(true)
      expect(json["data"]).to be_an(Array)
      expect(json["data"].first["name"]).to eq("chat_feature")
    end
  end

  describe "POST /create" do
    it "creates valid feature" do
      post api_feature_flags_path,
          params: { feature: { name: "new_feature", enabled: true, description: "desc" } }

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["success"]).to eq(true)
      expect(json["data"]["name"]).to eq("new_feature")
    end
  end

  describe "PATCH /update" do
    it "updates feature" do
      patch api_feature_flag_path(feature), params: { feature: { enabled: true } }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["success"]).to eq(true)
      expect(json["data"]["enabled"]).to eq(true)
    end
  end

  describe "GET /evaluate" do
   it "evaluates feature" do
    allow_any_instance_of(Api::FeatureFlagsController)
      .to receive(:current_user).and_return(user)

    get evaluate_api_feature_flag_path(feature)

    json = JSON.parse(response.body)
    expect(response).to have_http_status(:ok)
    expect(json["success"]).to eq(true)
    expect(json["data"]["feature"]).to eq("chat_feature")
   end
 end
end
