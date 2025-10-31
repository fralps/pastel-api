# frozen_string_literal: true

FactoryBot.define do
  factory :sleep do
    user
    title { 'Great dream' }
    date { Time.zone.today }
    description { 'Great description of my last night dream' }
    current_mood { 'Good mood' }
    intensity { 'clear' }
    happened { 'sleeping' }
    sleep_type { Sleep::SLEEP_TYPE[:dream] }

    # Traits pour faciliter la création
    trait :dream do
      sleep_type { Sleep::SLEEP_TYPE[:dream] }
    end

    trait :nightmare do
      sleep_type { Sleep::SLEEP_TYPE[:nightmare] }
    end

    trait :lucid do
      sleep_type { Sleep::SLEEP_TYPE[:lucid] }
    end

    trait :sleep_paralysis do
      sleep_type { Sleep::SLEEP_TYPE[:sleep_paralysis] }
    end

    trait :sleep_walking do
      sleep_type { Sleep::SLEEP_TYPE[:sleep_walking] }
    end

    trait :sleep_talking do
      sleep_type { Sleep::SLEEP_TYPE[:sleep_talking] }
    end

    trait :sleep_apnea do
      sleep_type { Sleep::SLEEP_TYPE[:sleep_apnea] }
    end

    trait :erotic do
      sleep_type { Sleep::SLEEP_TYPE[:erotic] }
    end
  end
end
