require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  let(:question) { create(:question) }
  let!(:vote_one) { create(:vote, value: 1, votable: question) }
  let!(:vote_two) { create(:vote, value: 1, votable: question) }
  let!(:vote_three) { create(:vote, value: -1, votable: question) }

  describe 'scopes' do
    it 'likes return only liked votes' do
      expect(Vote.likes).to eq([vote_one, vote_two])
    end
    it 'dislikes return only disliked votes' do
      expect(Vote.dislikes).to eq([vote_three])
    end
  end
end
