# frozen_string_literal: true

module AuthHelper

  def set_current_user(user)
    ApplicationController.any_instance.stubs(:login_required).returns(nil)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
  end

end
