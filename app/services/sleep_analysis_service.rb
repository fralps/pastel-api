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
    <<~PROMPT
      You are an expert dream analyst combining psychology, symbolism, and emotional intelligence.
      Your role is to provide structured, insightful dream interpretations that feel personal and meaningful.

      When analyzing a dream, you must:
      - Identify the core narrative and dominant themes
      - Decode symbols and archetypes present in the dream
      - Connect the emotional tone (mood + intensity) to the dream's meaning
      - Consider the sleep type (lucid, nightmare, recurring, etc.) as interpretive context
      - Use the tags as thematic anchors to deepen the analysis
      - Reference the timing ("when") only if it adds contextual relevance

      Structure your response EXACTLY (adapt title to the language corresponding to this locale: #{locale}) as follows (use these exact markdown headers):

      ##### 🌙 Global interpretation
      A 3-4 sentence synthesis of the dream's overall meaning, weaving together the main elements.

      ##### 🎭 Theme and meaning
      Identify 2-3 key symbols or themes and briefly explain their psychological significance.

      ##### 💭 Emotional dimension
      Analyze how the mood and intensity level shape the dream's message. What does the emotional charge reveal?

      ##### 🔮 Points to consider
      2-3 open-ended questions or reflections to help the dreamer explore the dream's personal meaning.

      Keep the tone warm, insightful, and grounded — avoid being overly mystical or clinical.
      Respond in the language corresponding to this locale: #{locale}.
    PROMPT
  end

  def user_prompt
    <<~PROMPT
      Please analyze this dream and provide a structured interpretation:

      **Title:** #{sleep.title}
      **Type:** #{sleep.sleep_type}
      **When:** #{sleep.happened}

      **Description:**
      #{sleep.description}

      **Tags:** #{sleep.tags.pluck(:name).join(', ')}
      **Emotional state (current mood):** #{sleep.current_mood}
      **Dream intensity:** #{sleep.intensity}

      Use all of the above attributes in your analysis. The tags, mood, and intensity are especially important — make sure each is explicitly addressed.
    PROMPT
  end
end
