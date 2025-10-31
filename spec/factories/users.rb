# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { :user }
    confirmed_at { 1.day.ago }

    trait :other_user do
      sequence(:email) { |n| "other-#{n}@pastel.fr" }
      firstname { 'John' }
      lastname { 'Doe' }
    end

    trait :admin_user do
      email { 'admin@pastel.fr' }
      role { 'admin' }
    end
  end
end
