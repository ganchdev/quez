# frozen_string_literal: true

class AuthController < ApplicationController

  layout "auth"

  skip_before_action :login_required, only: [:new, :callback]
  before_action :redirect_if_logged_in, only: [:new, :callback]

  def new
  end

  def callback
    auth_data = provider_auth_data(request.env["omniauth.auth"]["info"])

    begin
      user = find_or_create_user(auth_data)
      create_auth_session(user)
      flash[:hello] = "👋" 
      redirect_to root_path
    rescue ActiveRecord::RecordInvalid
      redirect_to auth_path, alert: "There was an error signing in. Please try again."
    rescue StandardError => e
      Rails.logger.error("OmniAuth callback error: #{e.message}")

      redirect_to auth_path, alert: "Authentication failed. Please try again."
    end
  end

  def destroy
    auth_session.invalidate! if auth_session.is_a?(Authie::Session)

    redirect_to auth_path, notice: "You have been logged out successfully."
  end

  private

  def find_or_create_user(auth_data)
    user = User.find_or_initialize_by(email: auth_data[:email]) do |u|
      u.name = auth_data[:name]
      u.first_name = auth_data[:first_name]
      u.last_name = auth_data[:last_name]
      u.image = auth_data[:image]
    end

    user.save! if user.new_record?
    user
  end

  def provider_auth_data(auth)
    {
      email: auth["email"],
      name: auth["name"],
      first_name: auth["first_name"] || auth["name"]&.split&.first,
      last_name: auth["last_name"] || auth["name"]&.split&.last,
      image: auth["image"]
    }
  end

end
