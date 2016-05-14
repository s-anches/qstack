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

      it_behaves_like "json list", %w(id body created_at updated_at question_id best), :answer, "answers/0/"
    end

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'return 200 status code' do
        expect(response).to be_success
      end

      it_behaves_like "json list", %w(id body created_at updated_at question_id best), :answer, "answer/"

      context 'comments' do
        it 'include in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        it_behaves_like "json list", %w(id body created_at), :comment, "answer/comments/0/"
      end

      context 'attachments' do
        it 'include in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it_behaves_like "json list", %w(id url), :attachment, "answer/attachments/0/"
      end
    end

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
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

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end