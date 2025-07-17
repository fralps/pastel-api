# frozen_string_literal: true

# Sleep model
class Sleep < ApplicationRecord
  ITEMS_PER_PAGE = 8

  INTENSITY = {
    very_clear: 'very_clear',
    clear: 'clear',
    unclear: 'unclear',
    very_unclear: 'very_unclear'
  }.freeze

  HAPPENED = {
    falling_asleep: 'falling_asleep',
    sleeping: 'sleeping',
    waking_up: 'waking_up',
    napping: 'napping'
  }.freeze

  SLEEP_TYPE = {
    dream: 'dream',
    nightmare: 'nightmare',
    lucid: 'lucid',
    sleep_paralysis: 'sleep_paralysis',
    sleep_walking: 'sleep_walking',
    sleep_talking: 'sleep_talking',
    sleep_apnea: 'sleep_apnea',
    erotic: 'erotic'
  }.freeze

  belongs_to :user
  has_many :tags, -> { order('id ASC') }, dependent: :destroy, inverse_of: :sleep

  accepts_nested_attributes_for :tags, allow_destroy: true

  encrypts :title, :description, :current_mood

  validates :title, presence: true
  validates :date, presence: true
  validates :description, presence: true
  validates :current_mood, presence: true
  validates :intensity, inclusion: { in: INTENSITY.values }
  validates :happened, inclusion: { in: HAPPENED.values }
  validates :sleep_type, inclusion: { in: SLEEP_TYPE.values }

  scope :ordered_by_date, -> { order(date: :desc) }
  scope :group_by_month_from_current_year, lambda {
    group_by_month(:date, format: '%Y-%m')
      .where(
        date: Time.zone.now.all_year
      )
      .size
  }
  scope :years, ->(range) { group_by_year(:date, format: '%Y-%m', range:).size }
end
