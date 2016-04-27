class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, except: :create
  after_action :publish_to

  respond_to :js, :json

  def create
    authorize Answer
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
    respond_with(@answer)
  end

  def update
    authorize @answer
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    authorize @answer
    respond_with(@answer.destroy)
  end

  def set_best
    authorize @answer
    respond_with(@answer.set_best)
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def publish_to
      PrivatePub.publish_to("/questions/#{@answer.question_id}/answers",
            answer: @answer.to_json, attachments: @answer.attachments.to_json,
            question_owner_id: @answer.question.user_id.to_json,
            action: self.action_name, rating: @answer.rating
      ) if @answer.errors.empty?
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end
end
