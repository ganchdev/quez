# frozen_string_literal: true

module AuthHelper

  def set_current_user(user)
    ApplicationController.any_instance.stubs(:require_authentication).returns(false)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
  end

end
