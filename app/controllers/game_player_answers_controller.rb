# frozen_string_literal: true

class GamePlayerAnswersController < ApplicationController

  before_action :set_game
  before_action :set_game_question
  before_action :set_answer
  before_action :set_game_player

  # POST /games/:id/player_answer
  def create
    player_answer = PlayerAnswer.build(
      game_player: @game_player,
      game_question: @game_question,
      answer: @answer,
      correct: @answer.correct
    )

    time_at_answer = Time.current
    time_taken = @game_question.started_at.present? ? (time_at_answer - @game_question.started_a).round : 0
    bonus_points = calculate_speed_bonus(@game_question.question.points, time_taken)

    if player_answer.save
      if @answer.correct
        @game_player.award_points!(@game_question.question.points + bonus_points)
      end

      render json: { message: "Answer submitted successfully" }, status: :ok
    else
      render json: { error: @player_answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def calculate_speed_bonus(question_points, time_taken)
    return 0 if time_taken > 8

    if question_points > 10
      max_bonus = (question_points * 0.3).round
      scale = [(8 - time_taken) / 6.0, 1.0].min
      (scale * max_bonus).round
    else
      case time_taken
      when 0..2 then 3
      when 2..4 then 2
      when 4..6 then 1
      else 0
      end
    end
  end

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
