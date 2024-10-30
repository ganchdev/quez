# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[8.1]

  def change
    create_table :questions do |t|
      t.references :quiz, null: false
      t.text :text
      t.integer :points, default: 1
      t.integer :position

      t.timestamps
    end
  end

end
