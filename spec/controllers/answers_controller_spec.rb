require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question) }
  let!(:own_answer) { create(:answer, user: user, question: question) }
  let!(:foreign_answer) { create(:answer, question: question) }

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
    end

    context 'Author' do
      it 'delete his answer' do
        expect { delete :destroy, id: own_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question page' do
        delete :destroy, id: own_answer
        expect(response).to redirect_to question
      end
    end

    context 'Non-author' do
      it 'do not delete other owner answer' do
        expect { delete :destroy, id: foreign_answer }.to_not change(Answer, :count)
      end

      it 'redirect to question page' do
        delete :destroy, id: foreign_answer
        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'assigns the requested answer to @answer' do
        patch :update, id: own_answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq own_answer
      end

      it 'change his answer attributes' do
        patch :update, id: own_answer, answer: { body: 'new body' }, format: :js
        own_answer.reload
        expect(own_answer.body).to eq 'new body'
      end

      it 'do not change other owner answer attributes' do
        patch :update, id: foreign_answer, answer: { body: 'new body' }, format: :js
        foreign_answer.reload
        expect(foreign_answer.body).to_not eq 'new body'
      end

      it 'render update template' do
        patch :update, id: own_answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Non-authenticated user' do
      it 'do not change answer attributes' do
        patch :update, id: own_answer, answer: { body: 'new body' }, format: :js
        own_answer.reload
        expect(own_answer.body).to_not eq 'new body'
      end
    end
  end
end
