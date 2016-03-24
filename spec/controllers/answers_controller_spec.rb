require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:answer_other) { create(:answer, question: question) }

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do

      it 'save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'new answer have owner' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
      answer
      answer_other
    end

    context 'Author' do
      it 'delete his answer' do
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question page' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'Non-author' do
      it 'do not delete other owner answer' do
        expect { delete :destroy, id: answer_other, question_id: question }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        delete :destroy, id: answer_other, question_id: question
        expect(response).to redirect_to question
      end
    end
  end
end
