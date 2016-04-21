require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let!(:own_answer) { create(:answer, user: user, question: question) }
  let!(:foreign_answer) { create(:answer, question: question) }
  let!(:foreign_answer_two) { create(:answer, question: question, best: true) }
  let(:answer) { create(:answer) }

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
        expect { delete :destroy, id: own_answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: own_answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non-author' do
      it 'do not delete other owner answer' do
        expect { delete :destroy, id: foreign_answer, format: :js }.to_not change(Answer, :count)
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

  describe 'PATCH #set_best' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'set best answer flag on own question' do
        patch :set_best, id: foreign_answer, format: :json
        foreign_answer.reload
        expect(foreign_answer.best).to eq true
      end

      it 'change best answer on own question' do
        expect(foreign_answer_two.best).to eq true
        patch :set_best, id: foreign_answer, format: :json
        foreign_answer.reload
        foreign_answer_two.reload
        expect(foreign_answer_two.best).to eq false
        expect(foreign_answer.best).to eq true
      end

      it 'do not set best answer flag on foreign question' do
        patch :set_best, id: answer, format: :json
        answer.reload
        expect(answer.best).to eq false
      end
    end

    context 'Non-authenticated user' do
      it 'do not set best answer flag on any question' do
        patch :set_best, id: own_answer, format: :json
        own_answer.reload
        expect(own_answer.best).to eq false
      end
    end
  end

  describe 'PATCH #like' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'can not like own answer' do
        expect{ patch :like, id: own_answer, format: :json}.to_not change(own_answer.votes, :count)
      end

      it 'can like foreign answer' do
        expect{ patch :like, id: foreign_answer, format: :json }.to change(foreign_answer.votes, :count).by(1)
      end

      it 'can like only once' do
        expect{ patch :like, id: foreign_answer, format: :json }.to change(foreign_answer.votes, :count).by(1)
        expect{ patch :like, id: foreign_answer, format: :json }.to_not change(foreign_answer.votes, :count)
      end

      it 'render json' do
        json = %({"object": #{foreign_answer.id}, "rating": 1})
        patch :like, id: foreign_answer, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end

    context 'Non-authenticated user' do
      it 'can not like answer' do
        expect{ patch :like, id: foreign_answer, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        json = %({"error": "You need to sign in or sign up before continuing."})
        patch :like, id: foreign_answer, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'can not dislike own answer' do
        expect{ patch :dislike, id: own_answer, format: :json}.to_not change(own_answer.votes, :count)
      end

      it 'can dislike foreign answer' do
        expect{ patch :dislike, id: foreign_answer, format: :json }.to change(foreign_answer.votes, :count).by(1)
      end

      it 'can dislike only once' do
        expect{ patch :dislike, id: foreign_answer, format: :json }.to change(foreign_answer.votes, :count).by(1)
        expect{ patch :dislike, id: foreign_answer, format: :json }.to_not change(foreign_answer.votes, :count)
      end

      it 'render json' do
        json = %({"object": #{foreign_answer.id}, "rating": -1})
        patch :dislike, id: foreign_answer, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end

    context 'Non-authenticated user' do
      it 'can not dislike answer' do
        expect{ patch :dislike, id: foreign_answer, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        json = %({"error": "You need to sign in or sign up before continuing."})
        patch :dislike, id: foreign_answer, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'Authenticated user' do
      before do
        sign_in(user)
        patch :like, id: foreign_answer, format: :json
      end

      it 'Owner can delete his vote' do
        expect { delete :unvote, id: foreign_answer, format: :json }.to change(foreign_answer.votes, :count).by(-1)
      end

      it 'render json success' do
        json = %({"object": #{foreign_answer.id}, "rating": 0})
        delete :unvote, id: foreign_answer, format: :json
        expect(response.body).to be_json_eql(json)
      end

      it 'render json error' do
        json = %({"errors": "Object not found"})
        delete :unvote, id: foreign_answer, format: :json
        delete :unvote, id: foreign_answer, format: :json
        expect(response.status).to eq 404
        expect(response.body).to be_json_eql(json)
      end
    end
  end
end
