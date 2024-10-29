# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  points     :integer          default(1)
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
  validates :points,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 100
            }

  validate :image_size

  private

  def image_size
    return unless image.attached? && image.blob.byte_size > 2.megabytes

    errors.add(:image, "is too large. Maximum size is 2 MB.")
  end

end