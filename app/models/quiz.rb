# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  title      :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_quizzes_on_user_id  (user_id)
#

# frozen_string_literal: true

class Quiz < ApplicationRecord

  belongs_to :user

  validates :title, presence: true

end
