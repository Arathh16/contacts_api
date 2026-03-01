class ApplicationController < ActionController::API
  def render_ok(data: nil, message: "OK", meta: nil, status: :ok)
    render json: {
      success: true,
      code: Rack::Utils.status_code(status),
      message: message,
      data: data,
      meta: meta
    }, status: status
  end

  def render_error(message:, status:, errors: nil)
    render json: {
      success: false,
      code: Rack::Utils.status_code(status),
      message: message,
      errors: errors
    }, status: status
  end
end
