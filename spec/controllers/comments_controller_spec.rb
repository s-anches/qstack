require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let!(:own_comment) { create(:comment, user: user) }
  let!(:foreign_comment) { create(:comment) }

  before { sign_in(user) }

  describe "POST #create" do
    it 'loads question if parent object is question' do
      post :create, question_id: question, comment: attributes_for(:comment), format: :js
      expect(assigns(:commentable)).to eq question
    end

    it 'loads answer if parent object is answer' do
      post :create, answer_id: answer, comment: attributes_for(:comment), format: :js
      expect(assigns(:commentable)).to eq answer
    end

    context 'with valid attributes' do
      it "save new comment in the database" do
        expect { post :create, question_id: question.id, comment: attributes_for(:comment), format: :js }
          .to change(question.comments, :count).by(1)
      end

      it "new comment have owner" do
        expect { post :create, question_id: question.id, comment: attributes_for(:comment), format: :js }.to change(user.comments, :count).by(1)
      end

      it "render create template" do
        post :create, question_id: question.id, comment: attributes_for(:comment), format: :js
        expect(response).to render_template :create
      end

       it 'publish new comment' do
        expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/comments", instance_of(Hash))
        post :create, question_id: question.id, comment: attributes_for(:comment), format: :js
      end
    end

    context 'with invalid attributes' do
      it "does not save new comment in the database" do
        expect { post :create, question_id: question.id, comment: attributes_for(:invalid_comment), format: :js }
          .to_not change(Comment, :count)
      end
      
      it 'does not publish new question' do
        expect(PrivatePub).not_to receive(:publish_to)
        post :create, question_id: question.id, comment: attributes_for(:invalid_comment), format: :js
      end
    end
  end

  describe "DELETE #destroy" do
    context "author" do
      it "destroy his comment" do
        expect { delete :destroy, id: own_comment, format: :js }.to change(Comment, :count).by(-1)
      end
      it "render destroy template" do
        delete :destroy, id: own_comment, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "non-author" do
      it "do not destroy foreign comment" do
        expect { delete :destroy, id: foreign_comment, format: :js }.to_not change(Comment, :count)
      end
    end
  end

end
