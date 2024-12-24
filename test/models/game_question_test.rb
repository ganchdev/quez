# frozen_string_literal: true

# == Schema Information
#
# Table name: game_questions
#
#  id            :integer          not null, primary key
#  current_phase :integer          default("idle"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  game_id       :integer          not null
#  question_id   :integer          not null
#
# Indexes
#
#  index_game_questions_on_game_id      (game_id)
#  index_game_questions_on_question_id  (question_id)
#
require "test_helper"

class GameQuestionTest < ActiveSupport::TestCase

  def setup
    @game_question = game_questions(:one)
  end

  # Associations
  test "should belong to a game" do
    assert_respond_to @game_question, :game
    assert_not_nil @game_question.game
  end

  test "should belong to a question" do
    assert_respond_to @game_question, :question
    assert_not_nil @game_question.question
  end

  test "should have many player answers" do
    assert_respond_to @game_question, :player_answers
    assert @game_question.player_answers.is_a?(ActiveRecord::Associations::CollectionProxy)
  end

  test "should destroy dependent player answers" do
    player_answers(:one)
    assert_difference("PlayerAnswer.count", -1) do
      @game_question.destroy
    end
  end

  # Enums
  test "current_phase should have valid enum values" do
    assert_includes GameQuestion.current_phases.keys, "idle"
    assert_includes GameQuestion.current_phases.keys, "reading"
    assert_includes GameQuestion.current_phases.keys, "answering"
    assert_includes GameQuestion.current_phases.keys, "completed"
  end

  test "current_phase should default to idle" do
    new_game_question = GameQuestion.new(game: games(:one), question: questions(:one))
    assert_equal "idle", new_game_question.current_phase
  end

  # Methods
  test "answers_count should return correct counts" do
    player_answer = player_answers(:one)
    counts = @game_question.answers_count

    assert counts.is_a?(Hash)
    assert_equal 1, counts[player_answer.answer_id]
  end

end
