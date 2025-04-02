class AddStartedAtToGameQuestions < ActiveRecord::Migration[8.1]

  def change
    add_column :game_questions, :started_at, :datetime
  end

end
