# frozen_string_literal: true

require "test_helper"

class HasPositionTest < ActiveSupport::TestCase

  setup do
    @quiz = Quiz.create!(title: "Sample Quiz", user: users(:one))
    @question1 = @quiz.questions.create!(text: "First question", position: 1)
    @question2 = @quiz.questions.create!(text: "Second question", position: 2)
    @question3 = @quiz.questions.create!(text: "Third question") # No position set
  end

  test "should set position scope correctly" do
    assert_equal :quiz, Question.model_scope
  end

  test "should set position to last position if blank" do
    question_without_position = @quiz.questions.create!(text: "Fourth question")
    assert_equal 4, question_without_position.position
  end

  test "should reorder positions according to provided order" do
    # Expected new order: question3 -> question1 -> question2
    Question.reorder_positions([@question3.id, @question1.id, @question2.id])

    assert_equal [@question3, @question1, @question2], @quiz.questions.order(:position)
    assert_equal 1, @question3.reload.position
    assert_equal 2, @question1.reload.position
    assert_equal 3, @question2.reload.position
  end

end