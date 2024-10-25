# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[8.1]

  def change
    create_table :questions do |t|
      t.references :quiz, null: false
      t.text :text

      t.timestamps
    end
  end

end
