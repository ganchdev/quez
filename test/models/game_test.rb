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
    @user = users(:one)
  end

  test "should have a unique 12-character key after creation" do
    game = Game.new(quiz: quizzes(:one), host: @user)
    game.save!
    assert_not_nil game.key
    assert_equal 12, game.key.length
  end

  test "should have many players through game_players" do
    assert_respond_to @game, :players
    assert_includes @game.players, @user
  end

end
