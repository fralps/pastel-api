# frozen_string_literal: true

require 'net/http'

# Service to analyse sleep description using AI
# Request to Mistral AI API to get an intepretation of the sleep description
class SleepAnalysisService < ApplicationService
  attr_accessor :sleep
  attr_reader :mistral_api_key, :mistral_api_url

  def initialize(sleep)
    super()
    @mistral_api_key = ENV.fetch('MISTRAL_API_KEY', nil)
    @mistral_api_url = 'https://api.mistral.ai/v1/chat/completions'
    @sleep = sleep
  end

  def call
    response = send_request_to_mistral
    result = parse_response(response)
    update_sleep_with_analysis(result) if result.present?
  end

  private

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
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to get response from Mistral API: #{response.code} - #{response.message}"
    end
  rescue StandardError => e
    Rails.logger.error "Error while sending request to Mistral API: #{e.message}"
  end

  def parse_response(response)
    return response['choices'].first['message']['content'][1]['text'] if response.present?

    nil
  end

  def build_payload
    {
      model: 'magistral-small-2509',
      response_format: {
        type: 'text'
      },
      messages: [
        {
          role: 'system',
          content: 'You are a helpful assistant that analyzes dream description, tags and emotion' \
                   'in order to interpret the dream.'
        },
        {
          role: 'user',
          content: 'Analyze the following sleep description, tags and emotion and provide an interpretation of the dream:' \
                   "\n\nSleep title: #{sleep.title} \nSleep type: #{sleep.sleep_type} \nDescription: #{sleep.description}" \
                   "\nTags: #{sleep.tags.join(', ')} \nCurrent mood: #{sleep.current_mood} \nIntensity: #{sleep.intensity}" \
                   "\nWhen: #{sleep.happened}"
        }
      ]
    }.to_json
  end

  def update_sleep_with_analysis(analysis)
    sleep.update(analysis: analysis, analysis_done: true)
  end
end
