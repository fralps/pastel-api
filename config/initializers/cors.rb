# frozen_string_literal: true

FRONT_ORIGINS = [
  'http://localhost:8080',
  'https://staging-pastel-front.vercel.app'
].freeze

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins FRONT_ORIGINS

    resource '/api/v1/*',
             headers: :any,
             methods: :any,
             expose: ['Authorization', 'Content-Disposition'],
             max_age: 600,
             credentials: true
  end
end
