require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:own_question) { create :question, user: user }
  let(:foreign_question) { create :question }
  let(:questions) { create_list :question, 2 }
  let(:answers) { create_list(:answer, 5, question: own_question) }

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #index' do
    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: own_question }

    it 'assigns the requested question' do
      expect(assigns(:question)).to eq own_question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      sign_in(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'saves the new question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show page' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
      own_question
      foreign_question
    end

    context 'Author' do
      it 'delete his question' do
        expect { delete :destroy, id: own_question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: own_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'Non-author' do
      it 'do not delete other owner question' do
        expect { delete :destroy, id: foreign_question }.to_not change(Question, :count)
      end

      it 'redirect to question page' do
        delete :destroy, id: foreign_question
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'assigns the requested question to @question' do
        patch :update, id: own_question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq own_question
      end

      it 'change his question attributes' do
        patch :update, id: own_question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
        own_question.reload
        expect(own_question.title).to eq 'Edited title'
        expect(own_question.body).to eq 'Edited body'
      end

      it 'do not change foreign question attributes' do
        patch :update, id: foreign_question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
        foreign_question.reload
        expect(foreign_question.title).to_not eq 'Edited title'
        expect(foreign_question.body).to_not eq 'Edited body'
      end

      it 'render update template' do
        patch :update, id: own_question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Non-authenticated user' do
      it 'do not change question attributes' do
        patch :update, id: own_question, question: { title: 'Edited title', body: 'Edited body' }, format: :js
        own_question.reload
        expect(own_question.title).to_not eq 'Edited title'
        expect(own_question.body).to_not eq 'Edited body'
      end
    end
  end

  describe 'PATCH #like' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'can not like own question' do
        expect{ patch :like, id: own_question, format: :json}.to_not change(own_question.votes, :count)
      end

      it 'can like foreign question' do
        expect{ patch :like, id: foreign_question, format: :json }.to change(foreign_question.votes, :count).by(1)
      end

      it 'can like only once' do
        expect{ patch :like, id: foreign_question, format: :json }.to change(foreign_question.votes, :count).by(1)
        expect{ patch :like, id: foreign_question, format: :json }.to_not change(foreign_question.votes, :count)
      end

      it 'render json' do
        json = %({"object": #{foreign_question.id}, "rating": 1})
        patch :like, id: foreign_question, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end

    context 'Non-authenticated user' do
      it 'can not like question' do
        expect{ patch :like, id: foreign_question, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        json = %({"error": "You need to sign in or sign up before continuing."})
        patch :like, id: foreign_question, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'can not dislike own question' do
        expect{ patch :dislike, id: own_question, format: :json}.to_not change(own_question.votes, :count)
      end

      it 'can dislike foreign question' do
        expect{ patch :dislike, id: foreign_question, format: :json }.to change(foreign_question.votes, :count).by(1)
      end

      it 'can dislike only once' do
        expect{ patch :dislike, id: foreign_question, format: :json }.to change(foreign_question.votes, :count).by(1)
        expect{ patch :dislike, id: foreign_question, format: :json }.to_not change(foreign_question.votes, :count)
      end

      it 'render json' do
        json = %({"object": #{foreign_question.id}, "rating": -1})
        patch :dislike, id: foreign_question, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end

    context 'Non-authenticated user' do
      it 'can not dislike question' do
        expect{ patch :dislike, id: foreign_question, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        json = %({"error": "You need to sign in or sign up before continuing."})
        patch :dislike, id: foreign_question, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'Authenticated user' do
      before do
        sign_in(user)
        patch :like, id: foreign_question, format: :json
      end

      it 'Owner can delete his vote' do
        expect { delete :unvote, id: foreign_question, format: :json }.to change(foreign_question.votes, :count).by(-1)
      end

      it 'render json success' do
        json = %({"object": #{foreign_question.id}, "rating": 0})
        delete :unvote, id: foreign_question, format: :json
        expect(response.body).to be_json_eql(json)
      end

      it 'render json error' do
        json = %({"errors": "Object not found"})
        delete :unvote, id: foreign_question, format: :json
        delete :unvote, id: foreign_question, format: :json
        expect(response.status).to eq 404
        expect(response.body).to be_json_eql(json)
      end
    end
  end
end
