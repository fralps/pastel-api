# frozen_string_literal: true

# Job to analyse sleep description
class SleepAnalyseJob < ApplicationJob
  queue_as :default

  def perform(sleep_id, locale)
    sleep = Sleep.find_by(id: sleep_id)

    return if sleep.blank?

    SleepAnalysisService.call(sleep, locale)
  rescue StandardError => e
    Rails.logger.error("Error analyzing sleep with ID: #{sleep_id} - #{e.message}")
    sleep.update_column(:analysis_status, "not_started") if defined?(sleep) && sleep.present? && sleep.has_attribute?(:analysis_status)
    raise
  end
end
