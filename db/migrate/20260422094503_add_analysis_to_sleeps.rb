# frozen_string_literal: true

class AddAnalysisToSleeps < ActiveRecord::Migration[8.1]
  def change
    add_column :sleeps, :analysis, :text, null: true
  end
end
