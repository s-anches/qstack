shared_examples_for 'votable' do
  let (:model) { create ( described_class.to_s.underscore ) }
  let (:user) { create (:user) }

  it 'has votes' do
    expect { model.votes }.to_not raise_error
  end

  describe 'User can' do
    before { model.vote(user, 1) }

    it 'vote method' do
      expect(model.votes.count).to eq(1)
    end

    it 'unvote method' do
      model.unvote(user)

      expect(model.votes.count).to eq(0)
    end
  end

  describe 'is_liked?' do
    it 'return true if liked' do
      model.vote(user, 1)

      expect(model.is_liked?(user)).to eq true
    end

    it 'return false is disliked' do
      model.vote(user, -1)

      expect(model.is_liked?(user)).to eq false
    end
  end

  it 'rating method return rating of model' do
    model.vote(user, 1)

    expect(model.rating).to eq 1
  end
end