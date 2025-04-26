# frozen_string_literal: true

# == Schema Information
#
# Table name: game_questions
#
#  id            :integer          not null, primary key
#  current_phase :integer          default("idle"), not null
#  started_at    :datetime
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

  # Callbacks
  test "does not change started_at when transitioning from answering to completed" do
    original_time = 2.minutes.ago
    @game_question.update!(current_phase: "answering", started_at: original_time)

    @game_question.current_phase = "completed"
    @game_question.save!

    assert_equal original_time.to_i, @game_question.started_at.to_i
  end

  test "does not set started_at when directly creating with answering phase" do
    freeze_time do
      Time.current
      new_question = GameQuestion.create!(
        game: games(:one),
        question: questions(:one),
        current_phase: "answering"
      )

      assert_equal nil, new_question.started_at
    end
  end

  test "does not set started_at when updating other attributes while in answering phase" do
    original_time = 2.minutes.ago
    @game_question.update!(current_phase: "answering", started_at: original_time)

    @game_question.updated_at = Time.current
    @game_question.save!

    assert_equal original_time.to_i, @game_question.started_at.to_i
  end

  test "preserves nil started_at when changing between non-answering phases" do
    @game_question.update!(current_phase: "idle", started_at: nil)

    @game_question.current_phase = "reading"
    @game_question.save!

    assert_nil @game_question.started_at
  end

  test "started_at is not set when changing to answering but validation fails" do
    @game_question.game = nil
    @game_question.current_phase = "answering"

    assert_not @game_question.save

    assert_nil @game_question.started_at
  end

  # Methods
  test "answers_count should return correct counts" do
    player_answer = player_answers(:one)
    counts = @game_question.answers_count

    assert counts.is_a?(Hash)
    assert_equal 1, counts[player_answer.answer_id]
  end

  test "sets started_at when changing to answering and it's nil" do
    @game_question.reading!
    assert_nil @game_question.started_at

    @game_question.current_phase = "answering"
    freeze_time do
      now = Time.current
      @game_question.save!

      assert_equal now, @game_question.started_at
    end
  end

  test "does not set started_at if already set" do
    @game_question.update!(started_at: 2.minutes.ago, current_phase: "reading")

    @game_question.current_phase = "answering"
    @game_question.save!

    # Should not overwrite started_at
    assert_in_delta 2.minutes.ago.to_i, @game_question.started_at.to_i, 1
  end

  test "does not set started_at if phase is not changing to answering" do
    @game_question.current_phase = "reading" # not transitioning to 'answering'
    @game_question.save!

    assert_nil @game_question.started_at
  end

  test "reward_players_if_completed awards points to correct answers and resets streaks for incorrect or no answers" do
    @game_question.answering!
    @game = @game_question.game
    @question = @game_question.question

    # Create players
    @player1 = game_players(:one)
    @player2 = game_players(:two)
    @player3 = game_players(:three) # Player 3 does not answer

    GamePlayer.any_instance.stubs(:streak_length).returns(4) # increase length by 1

    # Transition the phase to completed
    @game_question.current_phase = :completed
    @game_question.save!

    # Reload players to check updates
    @player1.reload
    @player2.reload
    @player3.reload

    # Assertions for player1 (correct answer)
    assert_equal 4, @player1.current_streak # Streak remains unchanged

    # Assertions for player2 (incorrect answer)
    assert_equal 0, @player2.current_streak # Streak reset to 0

    # Assertions for player3 (no answer)
    assert_equal 0, @player3.current_streak # Streak reset to 0
  end

end
