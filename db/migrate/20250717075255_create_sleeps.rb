# frozen_string_literal: true

class CreateSleeps < ActiveRecord::Migration[8.0]
  def change
    create_table :sleeps do |t|
      t.string :title, null: false
      t.datetime :date, null: false
      t.text :description, null: false
      t.string :current_mood
      t.string :intensity
      t.string :happened
      t.string :sleep_type, null: false, default: 'dream'
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
