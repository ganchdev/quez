# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "annotate"
gem "authie", github: "ganchdev/authie", branch: "main"
gem "dotenv-rails"
gem "importmap-rails"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", github: "rails/rails", branch: "main"
gem "sqlite3", ">= 2.1"
gem "stimulus-rails"
gem "turbo-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:windows, :jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: [:mri, :windows], require: "debug/prelude"
  gem "pry-remote"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
