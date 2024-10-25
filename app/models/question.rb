# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :integer          not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

class Question < ApplicationRecord

  belongs_to :quiz
  has_many :answers, dependent: :destroy

  has_one_attached :image

  validates :text, presence: true
  validate :answers_count

  private

  def answers_count
    return if new_record? || answers.empty?

    if answers.size < 2
      errors.add("not enough answers")
    elsif answers.size > 6
      errors.add("too many answers")
    end
  end

end
