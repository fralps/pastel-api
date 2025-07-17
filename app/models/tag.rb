# frozen_string_literal: true

# Polymorphic Tags table
class Tag < ApplicationRecord
  belongs_to :sleep, optional: true

  validates :name, presence: true
end
