# frozen_string_literal: true

module ApplicationHelper

  def app_name
    "&#490;uez&#63;".html_safe
  end

  def back_button(text: "← Back", css_class: "secondary", additional_options: {})
    button_tag(text.html_safe, {
      type: "button",
      class: css_class,
      onclick: "javascript:history.back()"
    }.merge(additional_options))
  end

  def form_errors(object)
    return unless object.errors.any?

    content_tag(:div, class: "form-errors") do
      content_tag(:ul) do
        object.errors.full_messages.map do |message|
          content_tag(:li, message)
        end.join.html_safe
      end
    end
  end

end
