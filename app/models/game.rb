# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id                  :integer          not null, primary key
#  ended_at            :datetime
#  key                 :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  current_question_id :integer
#  host_id             :integer          not null
#  quiz_id             :integer          not null
#
# Indexes
#
#  index_games_on_current_question_id  (current_question_id)
#  index_games_on_host_id              (host_id)
#  index_games_on_key                  (key)
#  index_games_on_quiz_id              (quiz_id)
#
class Game < ApplicationRecord

  belongs_to :quiz
  belongs_to :host, class_name: "User"
  belongs_to :current_question, class_name: "GameQuestion", optional: true
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players, source: :user
  has_many :game_questions, dependent: :destroy

  scope :in_progress, -> { where(ended_at: nil) }

  before_create :set_game_key
  after_create :create_game_questions

  def current_question_position
    return nil unless current_question

    @current_question_position ||= game_questions.order(:id).pluck(:id).index(current_question.id) + 1
  end

  def next_question!
    return unless game_questions.any?

    if current_question.nil?
      update(current_question: game_questions.order(:id).first)
    else
      next_question = game_questions.where("id > ?", current_question&.id).order(:id).first
      if next_question
        update(current_question: next_question)
      else
        update(ended_at: Time.current)
      end
    end
  end

  private

  def set_game_key
    self.key = SecureRandom.alphanumeric(12)
  end

  def create_game_questions
    quiz.questions.order(:position).each do |question|
      game_questions.create(question: question)
    end
  end

end
