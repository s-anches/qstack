class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  after_action :publish_to, only: [:create, :update, :destroy]

  respond_to :js, only: :update

  def index
    authorize Question
    respond_with(@questions = Question.all)
  end

  def show
    authorize @question
    respond_with(@question)
  end

  def new
    authorize Question
    respond_with(@question = Question.new)
  end

  def create
    authorize Question
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    authorize @question
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    authorize @question
    respond_with(@question.destroy)
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def publish_to
      PrivatePub.publish_to(
        "/questions", question: @question.to_json, action: self.action_name
      ) if @question.errors.empty?
    end

    def question_params
      params.require(:question).permit(
        :title, :body, attachments_attributes: [:id, :file, :_destroy]
      )
    end
end
