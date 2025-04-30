# frozen_string_literal: true

require "test_helper"

class GamePlayerAnswersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @game = games(:one)
    @game_question = game_questions(:one)
    @correct_answer = answers(:correct)
    @incorrect_answer = answers(:incorrect)
    @game_player = game_players(:one)

    set_current_user(@user)
  end

  test "should create player answer" do
    @game_question.update(started_at: 10.seconds.ago)

    assert_difference("PlayerAnswer.count") do
      post player_answer_game_path(@game), params: {
        game_question_id: @game_question.id,
        selected_answer_id: @correct_answer.id
      }
    end

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_equal "Answer submitted successfully", response_json["message"]
  end

end
