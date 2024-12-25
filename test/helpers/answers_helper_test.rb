# frozen_string_literal: true

require "test_helper"

class AnswersHelperTest < ActionView::TestCase

  test "renders the default label" do
    # When correct and selected are not specified (false by default)
    result = render_answers_label("question[answer]", "My answer text", 0)

    # Check the overall structure
    assert_match(/<label.*>/, result)
    assert_match(/<\/label>/, result)

    # The 'for' attribute in the label should match what Rails generates
    # Typically, label_tag("question[answer]") => for="question_answer"
    # But if your form input has a specific ID, adjust accordingly.
    # We'll just ensure it includes 'question_answer'.
    assert_includes result, 'for="question_answer"'

    # Ensure default classes
    assert_includes result, 'class="answer-label"'
    refute_includes result, "answered"
    refute_includes result, "answer-label-correct"
    refute_includes result, "selected"

    # Check that the letter and text are included
    assert_includes result, ">A<" # Index 0 should render "A"
    assert_includes result, "My answer text"
  end

  test "renders label for a correct answer" do
    result = render_answers_label("question[answer]", "Correct answer text", 1, correct: true)

    # Check classes
    assert_includes result, "answer-label"
    assert_includes result, "answered"
    assert_includes result, "answer-label-correct"
    refute_includes result, "selected"

    # Check letter for index = 1 => "B"
    assert_includes result, ">B<"
    assert_includes result, "Correct answer text"
  end

  test "renders label for a selected (but not correct) answer" do
    result = render_answers_label("question[answer]", "Selected answer text", 2, selected: true)

    assert_includes result, "answer-label"
    assert_includes result, "answered"
    assert_includes result, "selected"
    refute_includes result, "answer-label-correct"

    # Check letter for index = 2 => "C"
    assert_includes result, ">C<"
    assert_includes result, "Selected answer text"
  end

  test "renders label for a correct and selected answer" do
    result = render_answers_label("question[answer]", "Correct and selected", 3, correct: true, selected: true)

    assert_includes result, "answer-label"
    assert_includes result, "answered"
    assert_includes result, "answer-label-correct"
    assert_includes result, "selected"

    # Check letter for index = 3 => "D"
    assert_includes result, ">D<"
    assert_includes result, "Correct and selected"
  end

end
