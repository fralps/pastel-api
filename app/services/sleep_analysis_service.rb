# frozen_string_literal: true

require 'net/http'

# Service to analyse sleep description using AI
# Request to Mistral AI API to get an interpretation of the sleep description
class SleepAnalysisService < ApplicationService
  attr_accessor :sleep
  attr_reader :mistral_api_key, :mistral_api_url, :locale

  # Initializes the service with the sleep record to analyze.
  # Reads the Mistral API key from the environment and sets the API endpoint.
  def initialize(sleep, locale)
    super()
    @mistral_api_key = ENV.fetch('MISTRAL_API_KEY', nil)
    @mistral_api_url = 'https://api.mistral.ai/v1/chat/completions'
    @sleep = sleep
    @locale = locale
  end

  # Entry point of the service.
  # Sends the sleep data to Mistral, parses the response, and persists the analysis.
  def call
    response = send_request_to_mistral
    result = parse_response(response) if response.present?
    update_sleep_with_analysis(result) if result.present?
  end

  private

  # Builds and sends an HTTPS POST request to the Mistral API.
  # Returns the parsed JSON body on success, or logs an error and returns nil on failure.
  def send_request_to_mistral
    uri = URI(mistral_api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {
                                    'Content-Type' => 'application/json',
                                    'Authorization' => "Bearer #{mistral_api_key}"
                                  })
    request.body = build_payload
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      response.body
    else
      Rails.logger.error "Failed to get response from Mistral API: #{response.code} - #{response.message}"
      sleep.mark_as_analysis_not_started

      nil
    end
  rescue StandardError => e
    Rails.logger.error "Error while sending request to Mistral API: #{e.message}"
    sleep.mark_as_analysis_not_started

    nil
  end

  # Extracts the analysis text from the Mistral API response.
  # Returns nil if the response is blank.
  def parse_response(raw_response)
    response = JSON.parse(raw_response)
    return response['choices'].first['message']['content'][1]['text'] if response.present?

    nil
  end

  # Builds the JSON payload for the Mistral chat completions API.
  # Uses the magistral-small-2509 model with a system prompt for dream interpretation
  # and a user message containing the sleep attributes (title, type, description, tags, mood, intensity, when).
  def build_payload
    {
      model: 'magistral-small-2509',
      response_format: {
        type: 'text'
      },
      messages: [
        {
          role: 'system',
          content: system_prompt
        },
        {
          role: 'user',
          content: user_prompt
        }
      ]
    }.to_json
  end

  # Persists the AI-generated analysis on the sleep record and marks the analysis as done.
  def update_sleep_with_analysis(analysis)
    sleep.mark_as_analysis_done(analysis)
  end

  def system_prompt
    'You are a helpful assistant that analyzes dreams in order to interpret the dream.' \
      'You need to respond with a concise interpretation of the dream based on the provided information.' \
      "\n\nSleep title, description, tags, sleep type, intensity, and emotion will be provided in the user message. " \
      'Focus on providing insights about the possible meaning of the dream, the emotions involved, and any relevant symbolism.' \
      'Keep the interpretation concise and relevant to the provided sleep information.' \
      "You will need to respond in the same language as the provided locale: #{locale}."
  end

  def user_prompt
    'Analyze the following sleep description, tags and emotion and provide an interpretation of the dream:' \
      "\n\nSleep title: #{sleep.title}" \
      "\nSleep type: #{sleep.sleep_type}" \
      "\nDescription: #{sleep.description}" \
      "\nTags: #{sleep.tags.join(', ')}" \
      "\nCurrent mood: #{sleep.current_mood}" \
      "\nIntensity: #{sleep.intensity}" \
      "\nWhen: #{sleep.happened}"
  end
end
