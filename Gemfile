# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.1.1'

# Pagination
gem 'pagy'

# Use postgresql as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 7.1'

# JSON serialization
gem 'blueprinter'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Authentication
gem 'devise'
gem 'devise-jwt'

# ENV variables
gem 'dotenv'

# Needed in production for initial staging database seed
gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'main', require: false

# Handle statistics database queries
gem 'groupdate'

# Handle email catching
gem 'letter_opener_web'

# Fast JSON
gem 'oj'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  gem 'bundler-audit'
  gem 'rspec-json_expectations'
  gem 'rspec-rails', '~> 8.0.2'
  gem 'rubocop', require: false
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
  gem 'rubycritic', require: false
  gem 'spring-commands-rspec'
end

group :development do
  # Used for annotate models, serializers and models specs
  gem 'brakeman'
  gem 'bullet'
  gem 'listen', '~> 3.9'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'db-query-matchers'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:windows, :jruby]
