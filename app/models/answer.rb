# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  color       :string
#  correct     :boolean          default(FALSE), not null
#  position    :integer
#  text        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer          not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#

class Answer < ApplicationRecord

  include HasPosition

  position_scope :question

  belongs_to :question

  MAX_ANSWERS = 6

  validates :text, presence: true
  validates :correct, inclusion: [true, false]

  validate :answer_limit

  private

  def answer_limit
    return unless question.answers.count >= MAX_ANSWERS

    errors.add(:base, "Cannot add more than #{MAX_ANSWERS} answers to a question")
  end

end
