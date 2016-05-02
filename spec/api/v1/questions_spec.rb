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

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
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

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w(id url).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end
    end
    
    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
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

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        post "/api/v1/questions", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        post "/api/v1/questions", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
  end
end