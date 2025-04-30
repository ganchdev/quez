# frozen_string_literal: true

# == Schema Information
#
# Table name: player_answers
#
#  id               :integer          not null, primary key
#  correct          :boolean          not null
#  time_taken       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  answer_id        :integer          not null
#  game_player_id   :integer          not null
#  game_question_id :integer          not null
#
# Indexes
#
#  index_player_answers_on_answer_id         (answer_id)
#  index_player_answers_on_game_player_id    (game_player_id)
#  index_player_answers_on_game_question_id  (game_question_id)
#
require "test_helper"

class PlayerAnswerTest < ActiveSupport::TestCase

  def setup
    @player_answer = player_answers(:one)
  end

  # Associations
  test "should belong to an answer" do
    assert_respond_to @player_answer, :answer
    assert_not_nil @player_answer.answer
  end

  test "should belong to a game_player" do
    assert_respond_to @player_answer, :game_player
    assert_not_nil @player_answer.game_player
  end

  test "should belong to an game_question" do
    assert_respond_to @player_answer, :game_question
    assert_not_nil @player_answer.game_question
  end

end
