require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:own_object) { create :question, user: user }
  let(:foreign_object) { create :question }
  let(:questions) { create_list :question, 2 }
  let(:answers) { create_list(:answer, 5, question: own_object) }

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
    before { get :show, id: own_object }

    it 'assigns the requested question' do
      expect(assigns(:question)).to eq own_object
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

      it 'publish new question' do
        expect(PrivatePub).to receive(:publish_to).with("/questions", instance_of(Hash))
        post :create, question: attributes_for(:question)
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

      it 'does not publish new question' do
        expect(PrivatePub).not_to receive(:publish_to)
        post :create, question: attributes_for(:invalid_question)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
      own_object
      foreign_object
    end

    context 'Author' do
      it 'delete his question' do
        expect { delete :destroy, id: own_object }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: own_object
        expect(response).to redirect_to questions_path
      end

      it 'publish destroy question' do
        expect(PrivatePub).to receive(:publish_to).with("/questions", instance_of(Hash))
        delete :destroy, id: own_object
      end
    end

    context 'Non-author' do
      it 'do not delete other owner question' do
        expect { delete :destroy, id: foreign_object }.to_not change(Question, :count)
      end

      it 'redirect to question page' do
        delete :destroy, id: foreign_object
        expect(response).to redirect_to root_path
      end

      it 'does not publish destroy question' do
        expect(PrivatePub).not_to receive(:publish_to)
        delete :destroy, id: foreign_object
      end
    end
  end

  describe 'PATCH #update' do
    context 'Authenticated user' do
      before { sign_in(user) }

      context 'his question' do
        it 'assigns the requested question to @question' do
          patch :update, id: own_object, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq own_object
        end

        it 'change his question attributes' do
          patch :update, id: own_object, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          own_object.reload
          expect(own_object.title).to eq 'Edited title'
          expect(own_object.body).to eq 'Edited body'
        end

        it 'render update template' do
          patch :update, id: own_object, question: attributes_for(:question), format: :js
          expect(response).to render_template :update
        end

        it 'publish update question' do
          expect(PrivatePub).to receive(:publish_to).with("/questions", instance_of(Hash))
          patch :update, id: own_object, question: attributes_for(:question), format: :js
        end
      end

      context 'foreign question' do
        it 'do not change foreign question attributes' do
          patch :update, id: foreign_object, question: { title: 'Edited title', body: 'Edited body' }, format: :js
          foreign_object.reload
          expect(foreign_object.title).to_not eq 'Edited title'
          expect(foreign_object.body).to_not eq 'Edited body'
        end

        it 'does not publish update question' do
          expect(PrivatePub).not_to receive(:publish_to)
          patch :update, id: foreign_object, question: { title: 'Edited title', body: 'Edited body' }, format: :js
        end
      end
    end

    context 'Non-authenticated user' do
      it 'do not change question attributes' do
        patch :update, id: own_object, question: { title: 'Edited title', body: 'Edited body' }, format: :js
        own_object.reload
        expect(own_object.title).to_not eq 'Edited title'
        expect(own_object.body).to_not eq 'Edited body'
      end

      it 'does not publish update question' do
        expect(PrivatePub).not_to receive(:publish_to)
        patch :update, id: own_object, question: { title: 'Edited title', body: 'Edited body' }, format: :js
      end
    end
  end

  it_behaves_like 'voted'
end
