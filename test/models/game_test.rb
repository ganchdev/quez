# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id                  :integer          not null, primary key
#  ended_at            :datetime
#  key                 :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  current_question_id :integer
#  host_id             :integer          not null
#  quiz_id             :integer          not null
#
# Indexes
#
#  index_games_on_current_question_id  (current_question_id)
#  index_games_on_host_id              (host_id)
#  index_games_on_key                  (key)
#  index_games_on_quiz_id              (quiz_id)
#
require "test_helper"

class GameTest < ActiveSupport::TestCase

  def setup
    @game = games(:one)
  end

  # Associations
  test "should belong to a quiz" do
    assert_respond_to @game, :quiz
    assert_not_nil @game.quiz
  end

  test "should belong to a host" do
    assert_respond_to @game, :host
    assert_not_nil @game.host
  end

  test "should optionally belong to a current question" do
    assert_respond_to @game, :current_question
  end

  test "should have many game players" do
    assert_respond_to @game, :game_players
    assert @game.game_players.is_a?(ActiveRecord::Associations::CollectionProxy)
  end

  test "should have many players through game players" do
    assert_respond_to @game, :players
    assert @game.players.is_a?(ActiveRecord::Associations::CollectionProxy)
  end

  test "should have many game questions" do
    assert_respond_to @game, :game_questions
  end

  test "should destroy dependent game players" do
    assert_difference("GamePlayer.count", -@game.game_players.count) do
      @game.destroy
    end
  end

  test "should destroy dependent game questions" do
    assert_difference("GameQuestion.count", -@game.game_questions.count) do
      @game.destroy
    end
  end

  # Scopes
  test "in_progress scope should return games without ended_at" do
    in_progress_games = Game.in_progress
    assert_includes in_progress_games, @game if @game.ended_at.nil?
    assert_not_includes in_progress_games, games(:ended_game)
  end

  # Callbacks
  test "should set a game key before creation" do
    new_game = Game.create(quiz: quizzes(:one), host: users(:one))
    assert_not_nil new_game.key
    assert_equal 12, new_game.key.length
  end

  test "should create game questions after creation" do
    quiz = quizzes(:one)
    new_game = Game.create(quiz: quiz, host: users(:one))
    assert_equal quiz.questions.count, new_game.game_questions.count
  end

  # Methods
  test "current_question_position should return correct position" do
    @game.update(current_question: game_questions(:id_1))
    position = @game.current_question_position
    assert_equal 1, position
  end

  test "current_question_position should return nil if no current question" do
    @game.update(current_question: nil)
    assert_nil @game.current_question_position
  end

  test "next_question! should update current_question to the next question" do
    first_question = game_questions(:id_1)
    second_question = game_questions(:id_2)

    @game.update(current_question: first_question)

    @game.next_question!
    assert_equal second_question, @game.current_question
  end

  test "next_question! should set ended_at if no more questions" do
    @game.update(current_question: @game.game_questions.last)

    @game.next_question!
    assert_not_nil @game.ended_at
  end

  test "next_question! should set the first question if current_question is nil" do
    first_question = game_questions(:id_1)
    @game.update(current_question: nil)

    @game.next_question!
    assert_equal first_question, @game.current_question
  end

end
