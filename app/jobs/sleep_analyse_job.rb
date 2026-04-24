# frozen_string_literal: true

# Job to analyse sleep description
class SleepAnalyseJob < ApplicationJob
  queue_as :default

  def perform(sleep_id, locale)
    sleep = Sleep.find_by(id: sleep_id)

    return if sleep.blank?
    return if sleep.analysis_status == 'done' || sleep.analysis_status == 'in_progress' || sleep.analysis.present?

    SleepAnalysisService.call(sleep, locale)
  rescue StandardError => e
    Rails.logger.error("Error analyzing sleep with ID: #{sleep_id} - #{e.message}")
    sleep.presence&.mark_as_analysis_not_started

    raise
  end
end
