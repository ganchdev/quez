# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  color       :string
#  correct     :boolean          default(FALSE), not null
#  position    :integer
#  text        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer          not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#

require "test_helper"

class AnswerTest < ActiveSupport::TestCase

  def setup
    @answer = Answer.new(text: "A programming language", correct: true, question: questions(:one))
  end

  test "should be valid with valid attributes" do
    assert @answer.valid?
  end

  test "should belong to a question" do
    assert_respond_to @answer, :question
  end

  test "text should be present" do
    @answer.text = nil
    assert_not @answer.valid?
  end

  test "correct should be true or false" do
    @answer.correct = nil
    assert_not @answer.valid?
  end

end
