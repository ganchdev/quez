class AddTimeTakenToPlayerAnswers < ActiveRecord::Migration[8.1]

  def change
    add_column :player_answers, :time_taken, :integer
  end

end
