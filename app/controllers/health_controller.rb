class HealthController < ActionController::API
  def show
    render json: { ok: true, time: Time.current.iso8601 }, status: :ok
  end
end
