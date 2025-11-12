class ChangeQuestionsDurationDefaultValueAgain < ActiveRecord::Migration[8.1]

  def up
    change_column_default :questions, :duration, from: 40, to: 20
  end

  def down
    change_column_default :questions, :duration, from: 20, to: 40
  end

end
