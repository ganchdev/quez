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

      Turbo::StreamsChannel.broadcast_refresh_to @game

      render :join
    end
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

  def next_question
    return unless host_user?

    @game.next_question!

    Turbo::StreamsChannel.broadcast_refresh_to @game

    ShowGameQuestionJob.perform_later @game.current_question
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
