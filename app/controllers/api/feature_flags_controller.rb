module Api
  class FeatureFlagsController < ApplicationController

    def current_user
      User.first
    end
    
    def index
      render json: {
        success: true,
        data: Feature.all
      }, status: :ok
    end

    def create
      feature = Feature.create!(feature_params)
      render json: {
        success: true,
        data: feature
      }, status: :created
    end

    def update
      feature = Feature.find(params[:id])
      feature.update!(feature_params)
      render json: {
        success: true,
        data: feature
      }, status: :ok
    end

    def evaluate
      feature = Feature.find(params[:id])
      enabled = FeatureFlagEngine.enabled?(feature.name, current_user, region: params[:region])
      render json: {
        success: true,
        data: {
          feature: feature.name,
          enabled: enabled
        }
      }, status: :ok
    end

    private

    def feature_params
      params.require(:feature).permit(:name, :enabled, :description)
    end
  end
end
