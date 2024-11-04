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

  test "playable? should return true if all questions have at least 2 answers" do
    @quiz = Quiz.new(
      title: "Example quiz 1",
      user: users(:one)
    )
    @quiz.save!

    question1 = @quiz.questions.create(text: "Question 1?")
    question2 = @quiz.questions.create(text: "Question 2?")

    question1.answers.create(text: "Answer 1", correct: true)
    question1.answers.create(text: "Answer 2", correct: false)
    question2.answers.create(text: "Answer 1", correct: true)
    question2.answers.create(text: "Answer 2", correct: false)

    assert @quiz.playable?, "Quiz should be playable when all questions have at least 2 answers"
  end

  test "playable? should return false if any question has fewer than 2 answers" do
    @quiz = Quiz.new(
      title: "Example quiz 2",
      user: users(:one)
    )
    @quiz.save!

    question1 = @quiz.questions.create(text: "Question 1?")
    question2 = @quiz.questions.create(text: "Question 2?")

    question1.answers.create(text: "Answer 1", correct: true)
    question2.answers.create(text: "Answer 1", correct: true)
    question2.answers.create(text: "Answer 2", correct: false)

    assert_not @quiz.playable?, "Quiz should not be playable when any question has fewer than 2 answers"
  end

end
