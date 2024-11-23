# frozen_string_literal: true

# == Schema Information
#
# Table name: game_questions
#
#  id            :integer          not null, primary key
#  current_phase :integer          default(0), not null
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
  # test "the truth" do
  #   assert true
  # end
end
