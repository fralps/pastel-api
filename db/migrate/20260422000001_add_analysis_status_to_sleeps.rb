# frozen_string_literal: true

class AddAnalysisStatusToSleeps < ActiveRecord::Migration[8.1]
  def change
    add_column :sleeps, :analysis_status, :string, default: 'not_started', null: false
    add_index :sleeps, :analysis_status
  end
end
