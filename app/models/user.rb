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

class User < ApplicationRecord

  has_many :sessions, dependent: :destroy
  has_many :quizzes, dependent: :destroy
  has_many :game_players
  has_many :games, through: :game_players

  validates :name, :email, :first_name, :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: true }

end
