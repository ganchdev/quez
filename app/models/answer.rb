# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  correct     :boolean          default(FALSE), not null
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

  belongs_to :question

  validates :text, :correct, presence: true

end
