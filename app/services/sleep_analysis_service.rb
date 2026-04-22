# frozen_string_literal: true

# Service to analyse sleep description using AI
class SleepAnalysisService < ApplicationService
  def initialize(sleep)
    super()
    @sleep = sleep
  end

  def call
    puts "Analyzing sleep with ID: #{@sleep.id}"
    puts "Description: #{@sleep.description}"
  end
end
