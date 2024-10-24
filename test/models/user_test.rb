# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  first_name :string
#  last_name  :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(
      name: "John Doe",
      email: "email@gmail.com",
      first_name: "John",
      last_name: "Doe",
      image: "https://example.com/profile_image"
    )
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should have a valid format" do
    @user.email = "invalid-email"
    assert_not @user.valid?
  end

end
