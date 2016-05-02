class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question
  before_action :find_answer, only: :show

  def index
    authorize :api
    @answers = @question.answers.all
    respond_with @answers
  end

  def show
    authorize :api
    respond_with @answer
  end

  def create
    authorize :api
    respond_with(@answer = @question.answers.create(answer_params.merge({ user: @user })))
  end

  private
    def find_question
      @question = Question.find(params[:question_id])
    end
    
    def find_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end