class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  private

  def record_audit!(company_id:, action:, resource_type:, resource_id:, metadata: {})
    AuditLog.create!(
      company_id: company_id,
      actor_user_id: current_actor_user_id,
      action: action,
      resource_type: resource_type,
      resource_id: resource_id,
      metadata: metadata
    )
  end

  def current_actor_user_id
    value = request.headers["X-Actor-User-Id"]
    value.present? ? value.to_i : nil
  end

  def render_not_found(error)
    render json: { error: "not_found", message: error.message }, status: :not_found
  end

  def render_unprocessable_entity(error)
    render json: { error: "validation_error", details: error.record.errors.to_hash(true) }, status: :unprocessable_entity
  end
end
