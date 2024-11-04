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

  def playable?
    return false if questions.empty?

    questions.none? { |q| q.answers.count < 2 }
  end

end
