# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  firstname              :string
#  lastname               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string           default("user")
#
FactoryBot.define do
  factory :user do
    email { 'francois@pastel.fr' }
    firstname { 'François' }
    lastname { 'Kinoba' }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { 1.day.ago }
    role { 'user' }
  end

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
