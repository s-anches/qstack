require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET /' do
    context 'authorized' do
      let(:me) { create(:user) }
      let!(:others) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'does not contain me' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it "contain profiles" do
          expect(response.body).to have_json_path("profiles")
      end

      it 'contains all other index' do
        expect(response.body).to include_json(others.to_json)
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get '/api/v1/profiles', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
  end
end