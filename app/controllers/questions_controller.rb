class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :verify_author, only: [:destroy, :update]

  respond_to :html, :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@questions)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))

    if @question.errors.empty?
      PrivatePub.publish_to "/questions", question: @question.to_json
    end
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def verify_author
      unless current_user.author_of?(@question)
        respond_with(@question)
      end
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
