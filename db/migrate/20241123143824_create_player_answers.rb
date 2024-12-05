# frozen_string_literal: true

class CreatePlayerAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :player_answers do |t|
      t.references :game_player, null: false
      t.references :game_question, null: false
      t.references :answer, null: false
      t.boolean :correct, null: false

      t.timestamps
    end
  end
end
