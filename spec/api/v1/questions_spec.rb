require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:questions) { create_list(:question, 5) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

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

      context 'answers' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
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
end