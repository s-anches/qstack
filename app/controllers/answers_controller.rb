class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      flash[:error] = "Invalid answer"
      redirect_to @question
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      flash[:notice] = "Answer succefully deleted."
      redirect_to @question
    else
      flash[:error] = "You not have permissions."
      redirect_to @question
    end
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
