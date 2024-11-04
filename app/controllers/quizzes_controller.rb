# frozen_string_literal: true

class QuizzesController < ApplicationController

  before_action :set_quiz, except: [:new, :index, :create]

  # GET /quizzes
  def index
    @quizzes = current_user.quizzes
  end

  # GET /quizzes/1
  def show
  end

  # GET /quizzes/new
  def new
    @quiz = Quiz.new
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes
  def create
    @quiz = current_user.quizzes.build(quiz_params)

    if @quiz.save
      redirect_to @quiz, notice: "Quiz was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quizzes/1
  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quiz was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /quizzes/1
  def destroy
    @quiz.destroy!
    redirect_to quizzes_path, notice: "Quiz was successfully destroyed.", status: :see_other
  end

  # POST /quizzes/1/play
  def play
    if @quiz.playable?
      @game = @quiz.games.create(host: current_user)
      redirect_to host_game_path(@game), notice: "Wait for users to start the game."
    else
      redirect_to @quiz, alert: "Quiz is not playable because some questions have fewer than 2 answers."
    end
  end

  private

  def set_quiz
    @quiz = Quiz.find(params.expect(:id))
  end

  def quiz_params
    params.expect(quiz: [:title])
  end

end
