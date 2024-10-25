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

require "test_helper"

class QuizTest < ActiveSupport::TestCase

  def setup
    @quiz = Quiz.new(
      title: "Example quiz",
      user: users(:one)
    )
  end

  test "should be valid with valid attributes" do
    assert @quiz.valid?
  end

  test "title should be present" do
    @quiz.title = nil
    assert_not @quiz.valid?
  end

end
