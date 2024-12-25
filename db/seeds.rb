# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.production?
  warn "Production seeds not available"
  exit 1
end

Quiz.destroy_all
Question.destroy_all
Answer.destroy_all

# Create Quizzes
puts "Creating quizzes..."
quizzes = User.all.map do |user|
  2.times.map do |i|
    Quiz.create!(
      title: "Quiz #{i + 1} by #{user.name}",
      user: user
    )
  end
end.flatten

# Create Questions for each Quiz
puts "Creating questions..."
questions = quizzes.map do |quiz|
  5.times.map do |i|
    Question.create!(
      quiz: quiz,
      text: "Question #{i + 1} for #{quiz.title}",
      points: rand(1..10),
      duration: 31,
      position: i + 1
    )
  end
end.flatten

# Create Answers for each Question
puts "Creating answers..."
questions.each do |question|
  correct_answer = rand(1..4)
  4.times do |i|
    Answer.create!(
      question: question,
      text: "Answer #{i + 1} for #{question.text}",
      correct: i + 1 == correct_answer,
      color: ["red", "blue", "green", "yellow"].sample,
      position: i + 1
    )
  end
end

puts "Seeding complete!"
