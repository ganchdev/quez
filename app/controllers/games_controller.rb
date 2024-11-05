# frozen_string_literal: true

class GamesController < ApplicationController

  before_action :set_game

  # GET /games/:id/host
  def host
    if host_user?
      render :host
    else
      redirect_to join_game_path(@game.key)
    end
  end

  # GET /:key
  def join
    if host_user?
      redirect_to host_game_path(@game)
    else
      @game.game_players.find_or_create_by(user: current_user)

      broadcast_replace_players_status

      render :join
    end
  end

  # DELETE /games/:id/quit
  def quit
    if host_user?
      # TODO: do stuff to stop the game
    else
      player = @game.game_players.find_by(user: current_user)
      player&.destroy!

      broadcast_replace_players_status

      redirect_to root_path
    end
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

  def broadcast_replace_players_status
    Turbo::StreamsChannel.broadcast_replace_to(
      @game,
      :players_status,
      target: [@game, :players_status],
      partial: "games/components/players_status",
      locals: { game: @game }
    )
  end

end
