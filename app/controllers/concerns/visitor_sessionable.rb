module VisitorSessionable
  extend ActiveSupport::Concern

  included do
    before_action :ensure_visitor_session!
  end

  private

  def ensure_visitor_session!
    token = cookies.signed[:vs_token]
    return if token && VisitorSession.exists?(session_token: token)

    token = SecureRandom.hex(16)
    cookies.signed[:vs_token] = {
      value: token,
      expires: 1.year.from_now,
      httponly: true
    }
    VisitorSession.create!(
      session_token: token,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
  end

  def current_visitor_session
    @current_visitor_session ||= VisitorSession.find_by!(session_token: cookies.signed[:vs_token])
  end
end
