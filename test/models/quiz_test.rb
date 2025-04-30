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

  test "playable? should return true when quiz has questions, all have at least 2 answers, and all have correct answers" do # rubocop:disable Layout/LineLength
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

    assert @quiz.playable?
    assert_nil @quiz.playable_error
  end

  test "playable? should return false when quiz has no questions" do
    @quiz = Quiz.new(
      title: "Example quiz - no questions",
      user: users(:one)
    )
    @quiz.save!

    assert_not @quiz.playable?
    assert_equal "Quiz is not playable because there are no questions in this quiz", @quiz.playable_error
  end

  test "playable? should return false when any question has fewer than 2 answers" do
    @quiz = Quiz.new(
      title: "Example quiz - insufficient answers",
      user: users(:one)
    )
    @quiz.save!

    question1 = @quiz.questions.create(text: "Question 1?")
    question2 = @quiz.questions.create(text: "Question 2?")

    question1.answers.create(text: "Answer 1", correct: true)
    question1.answers.create(text: "Answer 2", correct: false)
    question2.answers.create(text: "Answer 1", correct: true) # Only one answer for question2

    assert_not @quiz.playable?
    assert_equal "Quiz is not playable because some questions have fewer than 2 answers.", @quiz.playable_error
  end

  test "playable? should return false when any question lacks a correct answer" do
    @quiz = Quiz.new(
      title: "Example quiz - no correct answers",
      user: users(:one)
    )
    @quiz.save!

    question1 = @quiz.questions.create(text: "Question 1?")
    question2 = @quiz.questions.create(text: "Question 2?")

    question1.answers.create(text: "Answer 1", correct: true)
    question1.answers.create(text: "Answer 2", correct: false)
    question2.answers.create(text: "Answer 1", correct: false)  # No correct answer
    question2.answers.create(text: "Answer 2", correct: false)  # No correct answer

    assert_not @quiz.playable?
    assert_equal "Quiz is not playable because some quiestions don't have correct answers", @quiz.playable_error
  end

end
