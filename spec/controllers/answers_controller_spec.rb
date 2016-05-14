require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
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

      it 'publish new answer' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", instance_of(Hash))
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'does not publish new answer' do
        expect(PrivatePub).not_to receive(:publish_to)
        post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
    end

    context 'his answer' do
      it 'delete his answer' do
        expect { delete :destroy, id: own_answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: own_answer, format: :js
        expect(response).to render_template :destroy
      end

      it 'publish destroy answer' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", instance_of(Hash))
        delete :destroy, id: own_answer, format: :js
      end
    end

    context 'foreign answer' do
      it 'do not delete other owner answer' do
        expect { delete :destroy, id: foreign_answer, format: :js }.to_not change(Answer, :count)
      end

      it 'does not publish destroy answer' do
        expect(PrivatePub).not_to receive(:publish_to)
        delete :destroy, id: foreign_answer, format: :js
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in(user) }

      context 'his answer' do
        it 'assigns the requested answer to @answer' do
          patch :update, id: own_answer, answer: attributes_for(:answer), format: :js
          expect(assigns(:answer)).to eq own_answer
        end

        it 'change his answer attributes' do
          patch :update, id: own_answer, answer: { body: 'new body' }, format: :js
          own_answer.reload
          expect(own_answer.body).to eq 'new body'
        end

        it 'render update template' do
          patch :update, id: own_answer, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :update
        end

        it 'publish update answer' do
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", instance_of(Hash))
          patch :update, id: own_answer, answer: attributes_for(:answer), format: :js
        end
      end

      context 'foreign answer' do
        it 'do not change other owner answer attributes' do
          patch :update, id: foreign_answer, answer: { body: 'new body' }, format: :js
          foreign_answer.reload
          expect(foreign_answer.body).to_not eq 'new body'
        end

        it 'does not publish update answer' do
          expect(PrivatePub).not_to receive(:publish_to)
          patch :update, id: foreign_answer, answer: { body: 'new body' }, format: :js
        end
      end
    end

    context 'Non-authenticated user' do
      it 'do not change answer attributes' do
        patch :update, id: own_answer, answer: { body: 'new body' }, format: :js
        own_answer.reload
        expect(own_answer.body).to_not eq 'new body'
      end

      it 'does not publish update answer' do
        expect(PrivatePub).not_to receive(:publish_to)
        patch :update, id: own_answer, answer: { body: 'new body' }, format: :js
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:answer) { create(:answer) }
    let!(:foreign_answer_two) { create(:answer, question: question, best: true) }

    context 'Authenticated user' do
      before { sign_in(user) }

      context 'his question' do
        it 'set best answer flag' do
          patch :set_best, id: foreign_answer, format: :json
          foreign_answer.reload
          expect(foreign_answer.best).to eq true
        end

        it 'change best answer' do
          expect(foreign_answer_two.best).to eq true
          patch :set_best, id: foreign_answer, format: :json
          foreign_answer.reload
          foreign_answer_two.reload
          expect(foreign_answer_two.best).to eq false
          expect(foreign_answer.best).to eq true
        end

        it 'publish set_best answer' do
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/answers", instance_of(Hash))
          patch :set_best, id: foreign_answer, format: :json
        end
      end

      context 'foreign question' do
        it 'do not set best answer flag' do
          patch :set_best, id: answer, format: :json
          answer.reload
          expect(answer.best).to eq false
        end

        it 'does not publish set_best answer' do
          expect(PrivatePub).not_to receive(:publish_to)
          patch :set_best, id: answer, format: :json
        end
      end
    end

    context 'Non-authenticated user' do
      it 'do not set best answer flag on any question' do
        patch :set_best, id: own_answer, format: :json
        own_answer.reload
        expect(own_answer.best).to eq false
      end

      it 'does not publish set_best answer' do
        expect(PrivatePub).not_to receive(:publish_to)
        patch :set_best, id: own_answer, format: :json
      end
    end
  end

  it_behaves_like 'voted'
end
