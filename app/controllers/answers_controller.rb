class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      flash[:error] = "Invalid answer"
      redirect_to @question
    end
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end
