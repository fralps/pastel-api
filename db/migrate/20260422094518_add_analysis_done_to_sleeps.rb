# frozen_string_literal: true

class AddAnalysisDoneToSleeps < ActiveRecord::Migration[8.1]
  def change
    add_column :sleeps, :analysis_done, :boolean, default: false, null: false
  end
end
