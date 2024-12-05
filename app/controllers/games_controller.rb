# frozen_string_literal: true

class GamesController < ApplicationController

  before_action :set_game

  # GET /games/:id/host
  # GET /:key
  def show
    unless host_user?
      @game_player = @game.game_players.find_or_create_by(user: current_user)

      Turbo::StreamsChannel.broadcast_update_to(
        @game,
        target: [@game, :players_status],
        partial: "games/components/players_status",
        locals: { game: @game }
      )
    end

    render :show
  end

  # DELETE /games/:id/quit
  def quit
    if host_user?
      @game.update(ended_at: Time.current)

      Turbo::StreamsChannel.broadcast_refresh_to @game

      redirect_to host_game_path(@game)
    else
      player = @game.game_players.find_by(user: current_user)
      player&.destroy!

      Turbo::StreamsChannel.broadcast_refresh_to @game

      redirect_to root_path
    end
  end

  # POST /games/:id/start
  def start
    next_question
  end

  # GET /games/:id/next_question
  def next_question
    return unless host_user?

    @game.next_question!
    ShowGameQuestionJob.perform_later @game.current_question

    head :no_content
  end

  private

  def set_game
    @game = Game.find_by(key: params[:key]) || Game.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def host_user?
    @game.host == current_user
  end

end
