require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:questions) { create_list(:question, 5) }
      let!(:question) { questions.first }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 200 status code' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(5).at_path('questions')
      end

      it_behaves_like "json list", %w(id title body created_at updated_at), :question, "questions/0/"
    end

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'return 200 status code' do
        expect(response).to be_success
      end

      it_behaves_like "json list", %w(id title body created_at updated_at), :question, "question/"

      context 'comments' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        it_behaves_like "json list", %w(id body created_at), :comment, "question/comments/0/"
      end

      context 'attachments' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it_behaves_like "json list", %w(id url), :attachment, "question/attachments/0/"
      end
    end
    
    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'authorized' do
      context 'with valid attributes' do
        let(:attributes) { attributes_for(:question) }

        it 'create new question for user' do
          expect {
            post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes
          }.to change(user.questions, :count).by(1)
        end

        it "return created question" do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes
          attributes.each do |key, value|
            expect(response.body).to be_json_eql(value.to_json).at_path("question/#{key}")
          end
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { attributes_for(:question, body: nil, title: nil) }

        it 'does not create question' do
          expect {
            post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes
          }.to_not change(Question, :count)
        end

        it 'return error' do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes
          expect(response.status).to eq 422
          expect(response.body).to have_json_path('errors')
        end
      end
    end

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end