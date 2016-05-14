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

      it_behaves_like "json list", %w(id email created_at updated_at admin), :me, ""
      it_behaves_like "json path exclusion", %w(password encrypted_password), ""
    end

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/profiles/me", { format: :json }.merge(options)
    end
  end

  describe 'GET /' do
    context 'authorized' do
      let(:me) { create(:user) }
      let!(:others) { create_list(:user, 2) }
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
      
      0.upto 1 do |i|
        it_behaves_like "json list", %w(id email created_at updated_at), :me, "profiles/#{i}/", false
        it_behaves_like "json path exclusion", %w(password encrypted_password), "profiles/#{i}/"
      end
    end

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/profiles", { format: :json }.merge(options)
    end
  end
end