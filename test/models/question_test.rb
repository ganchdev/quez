# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :integer          not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

require "test_helper"

class QuestionTest < ActiveSupport::TestCase

  def setup
    @question = Question.new(text: "What is Ruby?", quiz: quizzes(:one))
  end

  test "should be valid with valid attributes" do
    assert @question.valid?
  end

  test "should belong to a quiz" do
    assert_respond_to @question, :quiz
  end

  test "should have many answers" do
    assert_respond_to @question, :answers
  end

  test "should have a text" do
    @question.text = nil
    assert_not @question.valid?
  end

  test "should allow attaching an image" do
    @question.image.attach(io: File.open("test/fixtures/files/sample_image.png"), filename: "sample_image.png",
                           content_type: "image/png")
    assert @question.image.attached?
  end

  test "should have more than 2 answers" do
    @question.save
    @question.answers.build(text: "A programming language", correct: true)

    assert_not @question.valid?
  end

  test "should have less than 6 answers" do
    @question.save
    @question.answers.build(text: "A programming language", correct: true)
    @question.answers.build(text: "A programming language", correct: true)
    @question.answers.build(text: "A programming language", correct: true)
    @question.answers.build(text: "A programming language", correct: true)
    @question.answers.build(text: "A programming language", correct: true)
    @question.answers.build(text: "A programming language", correct: true)
    @question.answers.build(text: "A programming language", correct: true)

    assert_not @question.valid?
  end

end
