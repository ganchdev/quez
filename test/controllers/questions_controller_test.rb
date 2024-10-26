# frozen_string_literal: true

require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @quiz = quizzes(:one)
    @question = questions(:three)

    set_current_user(@user)
  end

  test "should get new" do
    get new_quiz_question_path(@quiz)
    assert_response :success
  end

  test "should create question" do
    assert_difference("Question.count") do
      post quiz_questions_url(@quiz), params: { question: { text: @question.text, quiz_id: @question.quiz_id } }
    end

    assert_redirected_to quiz_question_url(@quiz, Question.last)
  end

  test "should show question" do
    get quiz_question_url(@quiz, @question)
    assert_response :success
  end

  test "should get edit" do
    get edit_quiz_question_url(@quiz, @question)
    assert_response :success
  end

  test "should update question" do
    patch quiz_question_url(@quiz, @question),
          params: { question: { text: @question.text, quiz_id: @question.quiz_id } }
    assert_redirected_to quiz_question_url(@quiz, @question)
  end

  test "should destroy question" do
    assert_difference("Question.count", -1) do
      delete quiz_question_url(@quiz, @question)
    end

    assert_redirected_to quiz_path(@quiz)
  end

end
