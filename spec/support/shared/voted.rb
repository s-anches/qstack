shared_examples_for 'voted' do

  let(:own_votable) { create(subject.model_klass.to_s.underscore.to_sym, user: user) }
  let(:foreign_votable) { create(subject.model_klass.to_s.underscore.to_sym) }

  describe 'PATCH #like' do
    context 'Authenticated user' do
      before { sign_in(user) }

      context 'own object' do
        it 'can not like' do
          expect{ patch :like, id: own_votable, format: :json}.to_not change(own_votable.votes, :count)
        end
      end

      context "foreign object"  do
        it 'can like only once time' do
          expect{ patch :like, id: foreign_votable, format: :json }.to change(foreign_votable.votes, :count).by(1)
          expect{ patch :like, id: foreign_votable, format: :json }.to_not change(foreign_votable.votes, :count)
        end

        it 'render json' do
          json = %({"object": #{foreign_votable.id}, "rating": 1})
          patch :like, id: foreign_votable, format: :json
          expect(response.body).to be_json_eql(json)
        end
      end
    end

    context 'Non-authenticated user' do
      it 'can not like object' do
        expect{ patch :like, id: foreign_votable, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        json = %({"error": "You need to sign in or sign up before continuing."})
        patch :like, id: foreign_votable, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'Authenticated user' do
      before { sign_in(user) }

      context 'own object' do
        it 'can not dislike' do
          expect{ patch :dislike, id: own_votable, format: :json}.to_not change(own_votable.votes, :count)
        end
      end

      context 'foreign object' do
        it 'can dislike' do
          expect{ patch :dislike, id: foreign_votable, format: :json }.to change(foreign_votable.votes, :count).by(1)
        end

        it 'can dislike only once' do
          expect{ patch :dislike, id: foreign_votable, format: :json }.to change(foreign_votable.votes, :count).by(1)
          expect{ patch :dislike, id: foreign_votable, format: :json }.to_not change(foreign_votable.votes, :count)
        end

        it 'render json' do
          json = %({"object": #{foreign_votable.id}, "rating": -1})
          patch :dislike, id: foreign_votable, format: :json
          expect(response.body).to be_json_eql(json)
        end
      end
    end

    context 'Non-authenticated user' do
      it 'can not dislike object' do
        expect{ patch :dislike, id: foreign_votable, format: :json }.to_not change(Vote, :count)
      end

      it 'render json' do
        json = %({"error": "You need to sign in or sign up before continuing."})
        patch :dislike, id: foreign_votable, format: :json
        expect(response.body).to be_json_eql(json)
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'Authenticated user' do
      before do
        sign_in(user)
        patch :like, id: foreign_votable, format: :json
      end

      it 'owner can delete his vote' do
        expect { delete :unvote, id: foreign_votable, format: :json }.to change(foreign_votable.votes, :count).by(-1)
      end

      it 'render json success' do
        json = %({"object": #{foreign_votable.id}, "rating": 0})
        delete :unvote, id: foreign_votable, format: :json
        expect(response.body).to be_json_eql(json)
      end

      it 'render json error' do
        delete :unvote, id: foreign_votable, format: :json
        delete :unvote, id: foreign_votable, format: :json
        expect(response.status).to eq 302
      end
    end
  end
end