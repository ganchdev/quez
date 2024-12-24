# frozen_string_literal: true

class ApplicationController < ActionController::Base

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :login_required

  rescue_from Authie::Session::InactiveSession, with: :auth_session_error
  rescue_from Authie::Session::ExpiredSession, with: :auth_session_error
  rescue_from Authie::Session::BrowserMismatch, with: :auth_session_error

  private

  def login_required
    return if logged_in?

    redirect_to auth_path, alert: "You must login to view this resource"
  end

  def redirect_if_logged_in
    return unless logged_in?

    redirect_to root_path, alert: "Can't access this page while logged in"
  end

  def auth_session_error
    redirect_to auth_path, alert: "Your session is no longer valid. Please login again to continue..."
  end

end
