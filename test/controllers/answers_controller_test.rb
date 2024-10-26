# frozen_string_literal: true

require "test_helper"

class AnswersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @quiz = @user.quizzes.first
    @question = @quiz.questions.first
    @answer = @question.answers.first

    set_current_user(@user)
  end

  test "should create answer" do
    assert_difference("Answer.count") do
      post quiz_question_answers_url(@quiz, @question),
           params: { answer: { correct: @answer.correct, question_id: @answer.question_id, text: @answer.text } }
    end

    assert_redirected_to quiz_question_url(@quiz, @question)
  end

  test "should get edit" do
    get edit_quiz_question_answer_url(@quiz, @question, @answer)
    assert_response :success
  end

  test "should update answer" do
    patch quiz_question_answer_url(@quiz, @question, @answer),
          params: { answer: { correct: @answer.correct, question_id: @answer.question_id, text: @answer.text } }
    assert_redirected_to quiz_question_url(@quiz, @question)
  end

  test "should destroy answer" do
    assert_difference("Answer.count", -1) do
      delete quiz_question_answer_url(@quiz, @question, @answer)
    end

    assert_redirected_to quiz_question_url(@quiz, @question)
  end

end
