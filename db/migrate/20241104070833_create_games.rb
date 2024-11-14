class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.references :quiz, null: false
      t.references :host, null: false
      t.references :current_question
      t.string :key, null: false, index: true
      t.datetime :ended_at

      t.timestamps
    end
  end
end
