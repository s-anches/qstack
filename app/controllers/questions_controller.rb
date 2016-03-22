class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question
    else
      flash[:error] = "INVALID ATTRIBUTES"
      render :new
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      flash[:notice] = "Question successfuly deleted."
      redirect_to questions_path
    else
      flash[:error] = "You can not delete not his question."
      redirect_to question_path(@question)
    end
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end
