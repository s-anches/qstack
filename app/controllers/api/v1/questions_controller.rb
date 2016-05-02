class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: :show

  def index
    respond_with Question.all, each_serializer: Api::V1::QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  private
    def find_question
      @question = Question.find(params[:id])
    end
end