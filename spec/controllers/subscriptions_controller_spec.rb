require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { sign_in(user) }

      it 'save subscribe to database' do
        expect { post :create, question_id: question.id, format: :js }.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'Non-authenticated user' do
      it 'not save subscribe to database' do
        expect { post :create, question_id: question.id, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before do
        sign_in(user)
        user.subscribe(question)
      end

      it 'delete subscribe from database' do
        expect(user.subscriptions.count).to eq 1

        delete :destroy, id: question.id, format: :js
        user.reload

        expect(user.subscriptions.count).to eq 0
      end
    end

    context 'Non-authenticated user' do
      it 'not delete subscribe from database' do
        expect { delete :destroy, id: question.id, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
