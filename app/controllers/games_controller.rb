# frozen_string_literal: true

class GamesController < ApplicationController

  before_action :set_game

  # GET /games/:id/host
  def host
    if @game.host == current_user
      render :host
    else
      redirect_to join_game_path(@game.key)
    end
  end

  # GET /:key
  def join
    if @game.host == current_user
      redirect_to host_game_path(@game)
    else
      render :join
    end
  end

  private

  def set_game
    @game = Game.find_by(key: params[:key]) || Game.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

end
