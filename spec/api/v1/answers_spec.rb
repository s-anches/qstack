require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:comment) { create(:comment, commentable: answer) }
  let!(:attachment) { create(:attachment, attachable: answer) }

  describe 'GET #index' do
    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'return 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at question_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET #show' do
    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'return 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at question_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'include in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'include in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        %w(id url).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end  
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'authorized' do
      context 'with valid attributes' do
        let(:attributes) { attributes_for(:answer) }

        it 'create new answer for question' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes
          }.to change(question.answers, :count).by(1)
        end

        it 'new answer have user' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes
          }.to change(user.answers, :count).by(1)
        end

        it "return created answer" do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes
          attributes.each do |key, value|
            expect(response.body).to be_json_eql(value.to_json).at_path("answer/#{key}")
          end
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { attributes_for(:answer, body: nil) }

        it 'does not create question' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes
          }.to_not change(Answer, :count)
        end

        it 'return error' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes
          expect(response.status).to eq 422
          expect(response.body).to have_json_path('errors')
        end
      end
    end

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        post "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
  end
end