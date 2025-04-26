# frozen_string_literal: true

class GamePlayerAnswersController < ApplicationController

  before_action :set_game
  before_action :set_game_question
  before_action :set_answer
  before_action :set_game_player

  # POST /games/:id/player_answer
  def create
    time_at_answer = Time.current
    time_taken = @game_question.started_at.present? ? (time_at_answer - @game_question.started_at).round : nil

    player_answer = PlayerAnswer.build(
      game_player: @game_player,
      game_question: @game_question,
      answer: @answer,
      correct: @answer.correct,
      time_taken: time_taken
    )

    if player_answer.save
      render json: { message: "Answer submitted successfully" }, status: :ok
    else
      render json: { error: @player_answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def set_game_question
    @game_question = @game.game_questions.find(params.expect(:game_question_id))
  end

  def set_answer
    @answer = @game_question.question&.answers&.find(params.expect(:selected_answer_id))
  end

  def set_game_player
    @game_player = @game.game_players.find_by!(user: current_user)
  end

end
