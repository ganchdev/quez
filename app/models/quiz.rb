# frozen_string_literal: true

# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_quizzes_on_user_id  (user_id)
#

class Quiz < ApplicationRecord

  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :games

  validates :title, presence: true

  attr_accessor :playable_error

  def playable?
    if questions.empty?
      self.playable_error = "Quiz is not playable because there are no questions in this quiz"
      false
    elsif questions.any? { |q| q.answers.count < 2 }
      self.playable_error = "Quiz is not playable because some questions have fewer than 2 answers."
      false
    elsif !questions.all? { |q| q.answers.exists?(correct: true) }
      self.playable_error = "Quiz is not playable because some quiestions don't have correct answers"
      false
    else
      true
    end
  end

end
