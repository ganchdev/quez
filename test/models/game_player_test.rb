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
    @game_player = game_players(:one)
  end

  test "should belong to a game" do
    assert_not_nil @game_player.game
  end

  test "should belong to a user" do
    assert_not_nil @game_player.user
  end

  test "points should be non-negative" do
    @game_player.points = -1
    assert_not @game_player.valid?
    assert_includes @game_player.errors[:points], "must be greater than or equal to 0"
  end

  test "should have a default points value of 0" do
    new_game_player = GamePlayer.new(game: games(:one), user: users(:two))
    assert_equal 0, new_game_player.points
  end

end
