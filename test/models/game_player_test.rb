# frozen_string_literal: true

# == Schema Information
#
# Table name: game_players
#
#  id             :integer          not null, primary key
#  current_streak :integer          default(0), not null
#  points         :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :integer          not null
#  user_id        :integer          not null
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

    result = GamePlayer.where(id: [player1, player2]).by_points
    assert_equal [player2, player1], result
  end

  ############ Instance Methods
  # find_answer_for
  test "find_answer_for should return the correct player answer" do
    player_answer = player_answers(:one)
    assert_equal player_answer, @game_player.find_answer_for(@game_question)
  end

  test "find_answer_for should return nil if no answer exists for the question" do
    game_question = game_questions(:two)
    assert_nil @game_player.find_answer_for(game_question)
  end

  # award_points
  test "awards zero points when both are zero" do
    @game_player.update!(points: 10)
    @game_player.award_points!(1, 30) # too late = 0 bonus
    assert_equal 11, @game_player.reload.points
  end

  test "awards only question points" do
    @game_player.update!(points: 10)
    @game_player.award_points!(10, 100) # too late = 0 bonus
    assert_equal 20, @game_player.reload.points
  end

  test "awards question and bonus points" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 0) # max bonus
    assert_equal 13, @game_player.reload.points
  end

  test "awards max bonus for high-value question answered fast" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 2) # full bonus 2s
    assert_equal 13, @game_player.reload.points
  end

  test "handles bonus cutoff at 8 seconds" do
    @game_player.update!(points: 0)
    @game_player.award_points!(9, 8) # bonus cutoff
    assert_equal 9, @game_player.reload.points
  end

  test "handles multiple awards correctly" do
    @game_player.update!(points: 0)
    3.times { @game_player.award_points!(10, 2) }
    # 10 + 3 (bonus) = 13 * 3 = 39
    assert_equal 39, @game_player.reload.points
  end

  test "awards minimum legal question points with no bonus" do
    @game_player.update!(points: 5)
    @game_player.award_points!(1, 10) # way too late
    assert_equal 6, @game_player.reload.points
  end

  test "awards minimum legal question points with max bonus" do
    @game_player.update!(points: 0)
    @game_player.award_points!(1, 1) # fast answer
    # low-point logic: bonus = 3
    assert_equal 4, @game_player.reload.points
  end

  test "awards max bonus at edge boundary time 2s" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 2)
    # still considered full scale bonus
    assert_equal 13, @game_player.reload.points
  end

  test "awards partial bonus at midpoint time 5s" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 5)
    assert_equal 11, @game_player.reload.points
  end

  test "awards 1 bonus point for low-value question at 5s" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 5)
    # falls into 4..6 range → bonus = 1
    assert_equal 11, @game_player.reload.points
  end

  test "no bonus exactly at cutoff time 8s" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 8)
    assert_equal 10, @game_player.reload.points
  end

  test "clamps negative time_taken to zero bonus" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, -3)
    # time_taken is negative, but logic returns 0 bonus
    assert_equal 10, @game_player.reload.points
  end

  test "awards correct bonus just under 4s (3s => 2 bonus)" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 3)
    assert_equal 12, @game_player.reload.points
  end

  test "awards correct bonus just under 6s (5s => 1 bonus)" do
    @game_player.update!(points: 0)
    @game_player.award_points!(10, 5)
    assert_equal 11, @game_player.reload.points
  end

  # Private methods

  # calculate_speed_bonus

  test "low-point exact 2s" do
    bonus = @game_player.send(:calculate_speed_bonus, 6, 2)
    assert_equal 3, bonus
  end

  test "low-point exact 4s" do
    bonus = @game_player.send(:calculate_speed_bonus, 6, 4)
    assert_equal 2, bonus # falls into 2..4 range (.. is inclusive)
  end

  test "low-point edge 6s" do
    bonus = @game_player.send(:calculate_speed_bonus, 6, 6)
    assert_equal 1, bonus
  end

  test "low-point above 6s" do
    bonus = @game_player.send(:calculate_speed_bonus, 6, 6.1)
    assert_equal 0, bonus
  end

  test "low-point just under 2s" do
    bonus = @game_player.send(:calculate_speed_bonus, 10, 1.9)
    assert_equal 3, bonus
  end

  test "low-point negative time (should still max tier)" do
    bonus = @game_player.send(:calculate_speed_bonus, 8, -1)
    assert_equal 0, bonus
  end

  test "zero-point question" do
    bonus = @game_player.send(:calculate_speed_bonus, 0, 1)
    assert_equal 3, bonus # falls under low-point logic
  end

  test "negative-point question" do
    bonus = @game_player.send(:calculate_speed_bonus, -5, 1)
    assert_equal 3, bonus # still low-point logic
  end

  test "bonus never negative even with high time" do
    bonus = @game_player.send(:calculate_speed_bonus, 100, 100)
    assert_equal 0, bonus
  end

  # calculate_streak_bonus

  test "calculate_streak_bonus returns 0 when streak is 1" do
    @game_player.stub :streak_length, 1 do
      result = @game_player.send(:calculate_streak_bonus, 50)
      assert_equal 0, result
    end
  end

  test "calculate_streak_bonus returns correct bonus when streak is > 1" do
    @game_player.stub :streak_length, 4 do
      result = @game_player.send(:calculate_streak_bonus, 40)
      # 40 * 4 * 0.25 = 40
      assert_equal 40, result
    end
  end

  test "calculate_streak_bonus rounds correctly" do
    @game_player.stub :streak_length, 3 do
      result = @game_player.send(:calculate_streak_bonus, 25)
      # 25 * 3 * 0.25 = 18.75 → 19
      assert_equal 19, result
    end
  end

  # streak_length

  test "streak_length returns 1 if no correct answers" do
    @game_player.stub :player_answers, stub(order: stub(pluck: [false, false, true])) do
      result = @game_player.send(:streak_length)
      assert_equal 1, result
    end
  end

  test "streak_length returns correct streak count - 3" do
    @game_player.stub :player_answers, stub(order: stub(pluck: [true, true, true, false, true])) do
      result = @game_player.send(:streak_length)
      assert_equal 3, result
    end
  end

  test "streak_length returns correct streak count - 2" do
    @game_player.stub :player_answers, stub(order: stub(pluck: [true, true, false, true])) do
      result = @game_player.send(:streak_length)
      assert_equal 2, result
    end
  end

  test "streak_length minimum is 1 even if all are wrong" do
    @game_player.stub :player_answers, stub(order: stub(pluck: [false, false, false])) do
      result = @game_player.send(:streak_length)
      assert_equal 1, result
    end
  end

end
