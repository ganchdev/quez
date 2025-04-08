class AddCurrentStreakToGamePlayers < ActiveRecord::Migration[8.1]

  def change
    add_column :game_players, :current_streak, :integer, default: 0, null: false
  end

end
