# frozen_string_literal: true

# Faker gem
require 'faker'

# To limit the database entries
# each time we seed we delete the previous ones and we reset database's ids
# require 'database_cleaner'

if Rails.env.production? && ENV.fetch('STAGING_ENV') && User.all.empty?
  User.create!(
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: 'j@j.com',
    password: 'password',
    role: 'user'
  )

  User.create!(
    firstname: 'François',
    lastname: 'Lps',
    email: 'fralps@fralps.com',
    password: 'password',
    role: 'admin'
  )
end

if Rails.env.development?
  # Clear existing data
  Sleep.destroy_all

  def time_rand(from = 2.years.ago, to = Time.zone.now)
    Time.zone.at(from + (rand * (to.to_f - from.to_f)))
  end

  # Create users
  Array.new(10) do
    User.new(
      firstname: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      role: 'user'
    ).tap do |user|
      user.skip_confirmation!
      user.save!
    end
  end

  # Create admin and regular user
  [
    { firstname: 'John', lastname: 'Doe', email: 'admin@yopmail.com', role: 'admin' },
    { firstname: 'John', lastname: 'Doe', email: 'j@j.com', role: 'user' }
  ].each do |user_data|
    User.create!(user_data.merge(password: 'password')).tap(&:confirm)
  end

  # Create sleeps for development user
  dev_user = User.find_by(email: 'j@j.com')

  # Create Sleeps
  60.times do
    Sleep.create!(
      title: Faker::Movie.quote,
      date: time_rand,
      description: Faker::Lorem.paragraph_by_chars(number: 200),
      current_mood: Faker::Lorem.sentence(word_count: 4),
      intensity: Sleep::INTENSITY[Sleep::INTENSITY.keys.sample],
      happened: Sleep::HAPPENED[Sleep::HAPPENED.keys.sample],
      sleep_type: Sleep::SLEEP_TYPE[Sleep::SLEEP_TYPE.keys.sample],
      user: dev_user
    )
  end

  tags = ['work', 'personal', 'ideas', 'todo', 'important', 'optional', 'health', 'nightmare', 'dream', 'lucid',
          'sleep_paralysis', 'sleep_walking', 'sleep_talking', 'sleep_apnea', 'erotic']

  Sleep.find_each do |sleep|
    rand(1..5).times do
      sleep.tags.create!(name: tags.sample)
    end
  end
end
