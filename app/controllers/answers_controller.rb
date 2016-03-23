class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params.merge({ user: current_user }))
    unless @answer.save
      flash[:error] = "Invalid answer"
    end
    redirect_to @question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "Answer succefully deleted."
    else
      flash[:error] = "You not have permissions."
    end
    redirect_to @question
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
