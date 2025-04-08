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

  test "should create player answer with correct answer" do
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

    @game_player.reload
    assert @game_player.points.positive?, "Player should receive points for correct answer"
  end

  test "should create player answer with incorrect answer" do
    @game_question.update(started_at: 10.seconds.ago)

    @game_player.update(current_streak: 5)

    assert_difference("PlayerAnswer.count") do
      post player_answer_game_path(@game), params: {
        game_question_id: @game_question.id,
        selected_answer_id: @incorrect_answer.id
      }
    end

    assert_response :success
    response_json = JSON.parse(response.body)
    assert_equal "Answer submitted successfully", response_json["message"]

    @game_player.reload
    assert_equal 0, @game_player.current_streak, "Player streak should reset to 0 after incorrect answer"
  end

  test "should handle answer when game_question has no started_at time" do
    @game_question.update(started_at: nil)

    assert_difference("PlayerAnswer.count") do
      post player_answer_game_path(@game), params: {
        game_question_id: @game_question.id,
        selected_answer_id: @correct_answer.id
      }
    end

    assert_response :success
  end

end
