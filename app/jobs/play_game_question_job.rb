# frozen_string_literal: true

class PlayGameQuestionJob < ApplicationJob

  queue_as :default

  def perform(game_question)
    Turbo::StreamsChannel.broadcast_refresh_to game_question.game

    game_question.reading!
    Turbo::StreamsChannel.broadcast_refresh_to game_question
    broadcast_countdown_timer(game_question, 5)

    game_question.answering!
    Turbo::StreamsChannel.broadcast_refresh_to game_question
    broadcast_countdown_timer(game_question, game_question.question.duration)

    game_question.completed!
    Turbo::StreamsChannel.broadcast_refresh_to game_question
  end

  private

  def broadcast_countdown_timer(game_question, seconds)
    remaining = seconds

    loop do
      if game_question.answering? && game_question.all_answered? && remaining > 5
        remaining = 5
      end

      Turbo::StreamsChannel.broadcast_update_to(
        game_question,
        target: [game_question, :timer],
        partial: "games/components/timer",
        locals: { game_question: game_question, seconds: remaining }
      )

      sleep 1

      remaining -= 1

      break if remaining.zero?
    end
  end

end
