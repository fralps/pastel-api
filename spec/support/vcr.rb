# frozen_string_literal: true

require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  # Directory where cassettes (recorded HTTP interactions) are stored
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'

  # Use WebMock as the HTTP stubbing library
  config.hook_into :webmock

  # Make VCR cassettes available via the :vcr metadata tag in RSpec
  config.configure_rspec_metadata!

  # Prevent the real Mistral API key from being recorded in cassettes
  config.filter_sensitive_data('<MISTRAL_API_KEY>') { ENV.fetch('MISTRAL_API_KEY', 'test_key') }
end
