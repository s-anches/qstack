require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  let(:user) { create :user }
  let(:question) { create :question }

  describe 'User can' do
    before { question.vote(user, 1) }

    it 'vote' do
      expect(question.votes.count).to eq 1
    end

    it 'unvote' do
      question.unvote(user)
      expect(question.votes.count).to eq 0
    end
  end

  describe 'is_liked?' do
    it 'return true if liked' do
      question.vote(user, 1)

      expect(question.is_liked?(user)).to eq true
    end

    it 'return false if disliked' do
      question.vote(user, -1)

      expect(question.is_liked?(user)).to eq false
    end
  end

  it 'Return question rating' do
    question.vote(user, 1)

    expect(question.rating).to eq 1
  end

end
