class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def set_best
    @answer.set_best if current_user.author_of?(@answer.question)
  end

  private
    def load_question
      @question = Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:file])
    end
end
