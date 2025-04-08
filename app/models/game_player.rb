# frozen_string_literal: true

# == Schema Information
#
# Table name: game_players
#
#  id             :integer          not null, primary key
#  current_streak :integer          default(0), not null
#  points         :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :integer          not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_game_players_on_game_id  (game_id)
#  index_game_players_on_user_id  (user_id)
#
class GamePlayer < ApplicationRecord

  belongs_to :game
  belongs_to :user
  has_many :player_answers

  scope :by_points, -> { order(points: :desc) }

  validates :points, numericality: { greater_than_or_equal_to: 0 }

  # @param [GameQuestion]
  # @return [PlayerAnswer, nil]
  def find_answer_for(game_question)
    player_answers.find_by(game_question: game_question)
  end

  # Awards points to the game player by incrementing their total points with
  # the sum of the current question points with all the bonuses they can get
  #
  # @param [Integer] question_points
  # @param [Integer, nil] time_taken
  # @return [GamePlayer]
  def award_points!(question_points, time_taken)
    speed_bonus = calculate_speed_bonus(question_points, time_taken)
    streak_bonus = calculate_streak_bonus(question_points)

    with_lock do
      update_columns(
        points: points + question_points + speed_bonus + streak_bonus,
        current_streak: streak_length
      )
    end
  end

  private

  # Calculates the bonus points a player earns for answering quickly.
  #
  # For high-value questions (> 10 points), the bonus is a percentage (30%)
  # of the question's value, scaled linearly based on how fast the answer was submitted.
  # Full bonus is awarded if answered in 2 seconds or less, and the bonus decreases
  # to zero by 8 seconds. Bonus is rounded to the nearest integer.
  #
  # For low-value questions (<= 10 points), a simple tiered bonus is applied
  #
  # time_taken is expected to be >= 0, or nil
  #
  # @param [Integer] question_points
  # @param [Integer, nil] time_taken
  # @return [Integer]
  def calculate_speed_bonus(question_points, time_taken)
    return 0 if time_taken.blank? || time_taken.negative? || time_taken > 8

    if question_points > 10
      max_bonus = (question_points * 0.3).round
      scale = [(8 - time_taken) / 6.0, 1.0].min
      (scale * max_bonus).round
    else
      case time_taken
      when 0..2 then 3
      when 2..4 then 2
      when 4..6 then 1
      else 0
      end
    end
  end

  # Calculates streak bonus based on the player's current
  # streak length, the bonus is calculated by
  # multiplying the question points with the streak length
  # and the bonus multiplier which is 25%
  #
  # @param [Integer] question_points
  # @return [Integer]
  def calculate_streak_bonus(question_points)
    return 0 if streak_length == 1

    (question_points * streak_length * 0.25).round
  end

  # @return [Integer]
  def streak_length
    recent_answers = player_answers.order(created_at: :desc).pluck(:correct)
    streak = recent_answers.take_while { |correct| correct }.count
    [streak, 1].max
  end

end
