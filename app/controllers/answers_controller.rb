# frozen_string_literal: true

class AnswersController < ApplicationController

  before_action :set_quiz
  before_action :set_question
  before_action :set_answer, only: [:edit, :update, :destroy]

  # GET /quizzes/1/questions/1/answers/new
  def new
    @answer = Answer.new
  end

  # GET /quizzes/1/questions/1/answers/1/edit
  def edit
  end

  # POST /quizzes/1/questions/1/answers
  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to quiz_question_path(@quiz, @question), notice: "Answer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quizzes/1/questions/1/answers/1
  def update
    if @answer.update(answer_params)
      redirect_to quiz_question_path(@quiz, @question), notice: "Answer was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/1/questions/1/answers/1
  def destroy
    @answer.destroy!
    redirect_to quiz_question_path(@quiz, @question), notice: "Answer was successfully destroyed.", status: :see_other
  end

  private

  def set_quiz
    @quiz = current_user.quizzes.find(params.expect(:quiz_id))
  end

  def set_question
    @question = @quiz.questions.find(params.expect(:question_id))
  end

  def set_answer
    @answer = @question.answers.find(params.expect(:id))
  end

  def answer_params
    params.expect(answer: [:text, :correct])
  end

end
