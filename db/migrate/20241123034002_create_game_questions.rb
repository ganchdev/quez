# frozen_string_literal: true

class CreateGameQuestions < ActiveRecord::Migration[8.1]

  def change
    create_table :game_questions do |t|
      t.references :game, null: false
      t.references :question, null: false
      t.integer :current_phase, default: 0, null: false

      t.timestamps
    end
  end

end
