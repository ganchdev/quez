# frozen_string_literal: true

# == Schema Information
#
# Table name: game_questions
#
#  id            :integer          not null, primary key
#  current_phase :integer          default("idle"), not null
#  started_at    :datetime
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

  before_save :set_started_at_if_answering
  before_save :reward_players_if_completed

  def answers_count
    player_answers.group(:answer_id).count
  end

  private

  def set_started_at_if_answering
    return unless current_phase_changed?(from: :reading, to: :answering)
    return unless started_at.nil?

    self.started_at = Time.current
  end

  def reward_players_if_completed
    return unless current_phase_changed?(from: :answering, to: :completed)

    all_players = game.game_players.includes(:player_answers)
    all_players.find_each do |player|
      current_question_answer = player.player_answers.find_by(game_question_id: id)
      unless current_question_answer
        player.player_answers.create(game_question: self, answer_id: -1, correct: false)
      end

      if current_question_answer&.correct
        player.award_points!(question.points, current_question_answer.time_taken)
      else
        player.update(current_streak: 0)
      end
    end

    true
  end

end
