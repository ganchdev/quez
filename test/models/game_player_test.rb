# frozen_string_literal: true

# == Schema Information
#
# Table name: game_players
#
#  id         :integer          not null, primary key
#  points     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_game_players_on_game_id  (game_id)
#  index_game_players_on_user_id  (user_id)
#
require "test_helper"

class GamePlayerTest < ActiveSupport::TestCase

  def setup
    @game_player = game_players(:one) # Assumes fixtures are set up
    @game_question = game_questions(:one)
  end

  # Associations
  test "should belong to a game" do
    assert_respond_to @game_player, :game
    assert_not_nil @game_player.game
  end

  test "should belong to a user" do
    assert_respond_to @game_player, :user
    assert_not_nil @game_player.user
  end

  test "should have many player answers" do
    assert_respond_to @game_player, :player_answers
  end

  # Validations
  test "points should be non-negative" do
    @game_player.points = -1
    assert_not @game_player.valid?
    assert_includes @game_player.errors[:points], "must be greater than or equal to 0"
  end

  test "should have a default points value of 0" do
    new_game_player = GamePlayer.new(game: games(:one), user: users(:two))
    assert_equal 0, new_game_player.points
  end

  # Scope
  test "by_points scope should order by points in descending order" do
    player1 = game_players(:one)
    player2 = game_players(:two)
    player1.update!(points: 20)
    player2.update!(points: 50)

    result = GamePlayer.by_points
    assert_equal [player2, player1], result
  end

  # Instance Methods
  test "find_answer_for should return the correct player answer" do
    player_answer = player_answers(:one)
    assert_equal player_answer, @game_player.find_answer_for(@game_question)
  end

  test "find_answer_for should return nil if no answer exists for the question" do
    game_question = game_questions(:two)
    assert_nil @game_player.find_answer_for(game_question)
  end
end
