# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  #
  # app_name
  #
  test "app_name returns expected HTML-safe text" do
    # The helper returns "&#490;uez&#63;" marked as HTML safe.
    result = app_name

    # Ensure it’s the exact string:
    assert_equal "&#490;uez&#63;", result

    # Ensure it’s marked as safe so Rails does not escape it further.
    assert result.html_safe?
  end

  #
  # back_button
  #
  test "back_button returns default text and attributes" do
    result = back_button

    # It should generate something like:
    # <button type="button" class="secondary" onclick="javascript:history.back()">← Back</button>

    assert_match %r{<button}, result
    assert_includes result, 'type="button"'
    assert_includes result, 'class="secondary"'
    assert_includes result, 'onclick="javascript:history.back()'
    assert_includes result, "← Back"
  end

  test "back_button can be customized with text, class, and additional attributes" do
    result = back_button(text: "Go Back", css_class: "custom-class", additional_options: { id: "my-button-id", data: { role: "test" } })
    # Example output:
    # <button type="button" class="custom-class" id="my-button-id" data-role="test" onclick="javascript:history.back()">Go Back</button>

    assert_match %r{<button}, result
    assert_includes result, 'class="custom-class"'
    assert_includes result, 'id="my-button-id"'
    assert_includes result, 'data-role="test"'
    assert_includes result, "Go Back"
  end

  #
  # form_errors
  #
  test "form_errors returns nil when object has no errors" do
    user = User.new
    # Assuming the model is valid or has no errors at this moment:
    assert_nil form_errors(user), "Expected form_errors to be nil when there are no errors"
  end

  test "form_errors renders a list of errors when object has errors" do
    user = User.new
    user.errors.add(:base, "Something went wrong")
    # Force a name attribute error
    user.errors.add(:name, "can't be blank")

    result = form_errors(user)

    assert_includes result, %(<div class="form-errors">)
    assert_includes result, %(<ul>)
    assert_includes result, %(<li>Something went wrong</li>)
    
    # If your actual error is "Name can't be blank":
    assert_includes result, %(<li>Name can&#39;t be blank</li>)

    # If your actual error is "Name Name can't be blank":
    # assert_includes result, %(<li>Name Name can&#39;t be blank</li>)

    assert_includes result, %(</ul>)
    assert_includes result, %(</div>)
  end

  #
  # bool_emoji
  #
  test "bool_emoji returns checkmark for true" do
    assert_equal "✅", bool_emoji(true)
  end

  test "bool_emoji returns X mark for false" do
    assert_equal "❌", bool_emoji(false)
  end

end
