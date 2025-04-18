# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]

  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :image

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

end
