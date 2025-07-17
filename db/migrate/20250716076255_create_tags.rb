# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.belongs_to :sleep, index: true

      t.timestamps
    end
  end
end
