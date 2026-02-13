module Api
  class FeatureOverridesController < ApplicationController
    before_action :set_feature
    before_action :set_override, only: [:update, :destroy]

    def create
      override = @feature.feature_overrides.create!(override_params)

      render json: {
        success: true,
        data: override
      }, status: :created
    end

    def update
      @override.update!(override_params)

      render json: {
        success: true,
        data: @override
      }, status: :ok
    end

    def destroy
      @override.destroy

      render json: {
        success: true,
        message: "Override deleted successfully"
      }, status: :ok
    end

    private

    def set_feature
      @feature = Feature.find(params[:feature_flag_id])
    end

    def set_override
      @override = @feature.feature_overrides.find(params[:id])
    end

    def override_params
      params.require(:override).permit(:enabled, :user_id, :group_id, :region)
    end
  end
end
