class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: :show
  before_action :find_user, only: :create

  def index
    authorize :api
    respond_with Question.all, each_serializer: Api::V1::QuestionCollectionSerializer
  end

  def show
    authorize :api
    respond_with @question
  end

  def create
    authorize :api
    respond_with(@question = @user.questions.create(question_params))
  end

  private
    def find_question
      @question = Question.find(params[:id])
    end

    def find_user
      @user = User.find(current_resource_owner.id)
    end

    def question_params
      params.require(:question).permit(:title, :body)
    end
end