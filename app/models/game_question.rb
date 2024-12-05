# frozen_string_literal: true

# == Schema Information
#
# Table name: game_questions
#
#  id            :integer          not null, primary key
#  current_phase :integer          default("idle"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  game_id       :integer          not null
#  question_id   :integer          not null
#
# Indexes
#
#  index_game_questions_on_game_id      (game_id)
#  index_game_questions_on_question_id  (question_id)
#
class GameQuestion < ApplicationRecord

  enum :current_phase, { idle: 0, reading: 1, answering: 2, completed: 3 }

  belongs_to :game
  belongs_to :question
  has_many :player_answers, dependent: :destroy

  def answers_count
    player_answers.group(:answer_id).count
  end

end
