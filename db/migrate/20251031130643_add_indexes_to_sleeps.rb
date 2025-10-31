# frozen_string_literal: true

class AddIndexesToSleeps < ActiveRecord::Migration[8.1]
  def change
    # Index simple sur sleep_type pour les requêtes de filtrage par type
    add_index :sleeps, :sleep_type, if_not_exists: true

    # Index composite sur user_id et sleep_type
    # Optimise les requêtes user.sleeps.where(sleep_type: ...)
    add_index :sleeps, [:user_id, :sleep_type], if_not_exists: true
  end
end
