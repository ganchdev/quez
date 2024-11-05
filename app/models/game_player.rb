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
class GamePlayer < ApplicationRecord

  belongs_to :game
  belongs_to :user

  validates :points, numericality: { greater_than_or_equal_to: 0 }

end