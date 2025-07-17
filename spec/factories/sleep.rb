# frozen_string_literal: true

FactoryBot.define do
  factory :sleep do
    title { 'Great dream' }
    date { Time.zone.today }
    description { 'Great description of my last night dream' }
    current_mood { 'Good mood' }
    intensity { 'clear' }
    happened { 'sleeping' }
    sleep_type { 'dream' }
  end
end
