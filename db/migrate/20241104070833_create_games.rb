class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.references :quiz, null: false
      t.string :key, null: false, index: true

      t.timestamps
    end
  end
end
