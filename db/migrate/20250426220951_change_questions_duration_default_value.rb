# frozen_string_literal: true

class ChangeQuestionsDurationDefaultValue < ActiveRecord::Migration[8.1]

  def up
    change_column_default :questions, :duration, from: 120, to: 40
  end

  def down
    change_column_default :questions, :duration, from: 40, to: 120
  end

end
