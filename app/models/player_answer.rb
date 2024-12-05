# frozen_string_literal: true

# == Schema Information
#
# Table name: player_answers
#
#  id               :integer          not null, primary key
#  correct          :boolean          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  answer_id        :integer          not null
#  game_player_id   :integer          not null
#  game_question_id :integer          not null
#
# Indexes
#
#  index_player_answers_on_answer_id         (answer_id)
#  index_player_answers_on_game_player_id    (game_player_id)
#  index_player_answers_on_game_question_id  (game_question_id)
#
class PlayerAnswer < ApplicationRecord

  belongs_to :answer
  belongs_to :game_player
  belongs_to :game_question

end
