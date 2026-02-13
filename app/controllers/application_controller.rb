class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def render_not_found(exception)
    render json: {
      success: false,
      error: "#{exception.model} not found"
    }, status: :not_found
  end

  def render_unprocessable(exception)
    render json: {
      success: false,
      errors: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: {
      success: false,
      error: exception.message
    }, status: :bad_request
  end
end
