# frozen_string_literal: true

module AnswersHelper

  def render_answers_label(name, text, index, classes = "answer-label", correct: false, selected: false)
    label_class = [
      classes,
      ("answered" if correct || selected),
      ("answer-label-correct" if correct),
      ("selected" if selected)
    ].compact.join(" ")

    label_tag name, class: label_class do
      concat(content_tag(:span, answer_letter(index)))
      concat(content_tag(:span, text))
    end
  end

  def answer_letter(index)
    ("A".."Z").to_a[index]
  end

end
