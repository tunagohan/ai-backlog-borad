class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  private

  def render_not_found(error)
    render json: { error: "not_found", message: error.message }, status: :not_found
  end

  def render_unprocessable_entity(error)
    render json: { error: "validation_error", details: error.record.errors.to_hash(true) }, status: :unprocessable_entity
  end
end
