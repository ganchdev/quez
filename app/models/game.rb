# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  key        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  host_id    :integer          not null
#  quiz_id    :integer          not null
#
# Indexes
#
#  index_games_on_host_id  (host_id)
#  index_games_on_key      (key)
#  index_games_on_quiz_id  (quiz_id)
#
class Game < ApplicationRecord

  belongs_to :quiz
  belongs_to :host, class_name: "User"
  has_many :game_players
  has_many :players, through: :game_players, source: :user

  before_validation :set_game_key

  private

  def set_game_key
    self.key = SecureRandom.alphanumeric(12)
  end

end
