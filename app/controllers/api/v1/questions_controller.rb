class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: :show

  def index
    authorize :api
    respond_with Question.all, each_serializer: Api::V1::QuestionCollectionSerializer
  end

  def show
    authorize :api
    respond_with @question, serializer: Api::V1::QuestionSerializer
  end

  def create
    authorize :api
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  private
    def find_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end