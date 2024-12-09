# frozen_string_literal: true

class QuestionsController < ApplicationController

  before_action :set_quiz
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /quizzes/1/questions/1
  def show
    @answers = @question.answers
  end

  # GET /quizzes/1/questions/new
  def new
    @question = Question.new
  end

  # GET /quizzes/1/questions/1/edit
  def edit
  end

  # POST /quizzes/1/questions
  def create
    @question = @quiz.questions.build(question_params)

    if @question.save
      redirect_to quiz_question_path(@quiz, @question), notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quizzes/1/questions/1
  def update
    if @question.update(question_params)
      redirect_to quiz_question_path(@quiz, @question), notice: "Question was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/1/questions/1
  def destroy
    @question.destroy!
    redirect_to quiz_path(@quiz), notice: "Question was successfully destroyed.", status: :see_other
  end

  private

  def set_quiz
    @quiz = current_user.quizzes.find(params.expect(:quiz_id))
  end

  def set_question
    @question = @quiz.questions.find(params.expect(:id))
  end

  def question_params
    params.expect(question: [:text, :image, :points, :duration])
  end

end
