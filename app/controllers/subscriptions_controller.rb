class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  respond_to :json

  def create
    authorize @question, :subscribe?
    current_user.subscribe(@question)
    render json: @question
  end

  def destroy
    authorize @question, :unsubscribe?
    current_user.unsubscribe(@question)
    render json: @question
  end

  private
    def load_question
      @question = Question.find(params[:question_id] || params[:id])
    end
end
