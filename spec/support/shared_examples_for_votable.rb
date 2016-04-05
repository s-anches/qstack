RSpec.shared_examples_for 'votable' do
  let (:model) { create ( described_class.to_s.underscore ) }
  let (:user) { create (:user) }

  it { should have_many(:votes).dependent(:destroy) }

  before { model.vote(user, 1) }

  describe 'vote' do
    it 'make new vote' do
      expect(model.votes.count).to eq(1)
    end
  end

  describe 'unvote' do
    it 'remove vote' do
      model.unvote(user)

      expect(model.votes.count).to eq(0)
    end
  end

  describe 'is_liked?' do
    it 'return true if liked' do
      expect(user.is_liked?(model)).to eq true
    end

    it 'return false if disliked' do
      model.vote(user, -1)

      expect(user.is_liked?(model)).to eq false
    end
  end

  describe 'rating' do
    it 'return average rating of model' do
      expect(model.rating).to eq 1
    end
  end
end