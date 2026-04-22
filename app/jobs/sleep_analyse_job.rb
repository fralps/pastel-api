# frozen_string_literal: true

# Job to analyse sleep description
class SleepAnalyseJob < ApplicationJob
  queue_as :default

  def perform(sleep_id)
    sleep = Sleep.find_by(id: sleep_id)

    return if sleep.blank?

    SleepAnalysisService.call(sleep)
  rescue StandardError => e
    Rails.logger.error("Error analyzing sleep with ID: #{sleep_id} - #{e.message}")
  end
end
