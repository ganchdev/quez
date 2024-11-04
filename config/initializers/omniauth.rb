# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV.fetch("GITHUB_KEY", nil), ENV.fetch("GITHUB_SECRET", nil), scope: "user:email"
  provider :google_oauth2, ENV.fetch("GOOGLE_CLIENT_ID", nil), ENV.fetch("GOOGLE_CLIENT_SECRET", nil),
           scope: "email, profile"
end
OmniAuth.config.full_host = ENV.fetch("APP_HOST", nil)
