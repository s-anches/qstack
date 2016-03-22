require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do

      it 'save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question page' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer)
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end
    end
  end
end
