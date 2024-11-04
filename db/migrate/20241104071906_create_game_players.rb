class CreateGamePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :game_players do |t|
      t.references :game, null: false
      t.references :user, null: false
      t.integer :points, default: 0, null: false

      t.timestamps
    end
  end
end
