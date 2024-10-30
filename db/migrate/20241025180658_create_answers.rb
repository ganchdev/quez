# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[8.1]

  def change
    create_table :answers do |t|
      t.references :question, null: false
      t.text :text
      t.boolean :correct, default: false, null: false
      t.string :color
      t.integer :position

      t.timestamps
    end
  end

end
