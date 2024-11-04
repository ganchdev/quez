# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  key        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :integer          not null
#
# Indexes
#
#  index_games_on_key      (key)
#  index_games_on_quiz_id  (quiz_id)
#
require "test_helper"

class GameTest < ActiveSupport::TestCase

  def setup
    @game = games(:one)
    @user = users(:one)
  end

  test "should have a unique 32-character key before validation" do
    game = Game.new(quiz: quizzes(:one))
    game.valid?
    assert_not_nil game.key
    assert_equal 32, game.key.length
  end

  test "should have many players through game_players" do
    assert_respond_to @game, :players
    assert_includes @game.players, @user
  end

end
