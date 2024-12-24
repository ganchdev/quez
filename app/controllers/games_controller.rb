# frozen_string_literal: true

class GamesController < ApplicationController

  before_action :set_game

  helper_method :host_user?

  layout "game"

  # GET /games/:id/host
  # GET /:key
  def show
    unless host_user?
      @game_player = @game.game_players.find_or_create_by(user: current_user)

      Turbo::StreamsChannel.broadcast_replace_to(
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
    return if @game.current_question&.idle?

    @game.next_question!
    PlayGameQuestionJob.perform_later @game.current_question

    head :no_content
  end

  # GET /games/:id/load_scoreboard
  def load_scoreboard
    Turbo::StreamsChannel.broadcast_remove_to(@game, target: [@game, :answers])

    Turbo::StreamsChannel.broadcast_replace_to(
      @game,
      target: [@game, :questions_header_actions],
      partial: "games/components/questions_header_actions",
      locals: {
        game_question: @game.current_question,
        host_user: host_user?,
        scoreboard: false
      }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      @game,
      target: [@game, :results],
      partial: "games/components/scoreboard",
      locals: { game: @game }
    )

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
