# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  # Main config
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Encrypt some database fields
    # See: https://guides.rubyonrails.org/active_record_encryption.html
    # Use default test keys for test environment to avoid ENV.fetch errors
    if Rails.env.test?
      config.active_record.encryption.primary_key = 'test_primary_key_for_testing_only'
      config.active_record.encryption.deterministic_key = 'test_deterministic_key_for_testing_only'
      config.active_record.encryption.key_derivation_salt = 'test_salt_for_testing_only'

      # Set test environment variables for Devise JWT
      ENV['DEVISE_JWT_SECRET_KEY'] = 'test_jwt_secret_key_for_testing_only'
      ENV['DEVISE_JWT_EXPIRATION_TIME'] = '86400' # 24 hours in seconds
      ENV['CONTACT_EMAIL'] = 'test@example.com'
      ENV['WEB_BASE_URL'] = 'http://localhost:3000'
    else
      config.active_record.encryption.primary_key = ENV.fetch('ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY')
      config.active_record.encryption.deterministic_key = ENV.fetch('ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY')
      config.active_record.encryption.key_derivation_salt = ENV.fetch('ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT')
    end

    # Use cookies storage
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
                          key: "_#{ENV.fetch('ENVIRONMENT', '').downcase}_pastel_session",
                          expire_after: 10.days

    config.i18n.default_locale = :fr

    config.time_zone = 'Europe/Paris'
  end
end
