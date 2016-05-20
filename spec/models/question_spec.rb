require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:question_two) { create(:question, created_at: 1.hour.ago) }
  let!(:questions_older) { create_list(:question, 2, created_at: 1.day.ago) }

  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:users).through(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it 'digest scope' do
    expect(Question.digest).to eq ([question, question_two])
  end

  it 'should be subscribe author after create' do
    expect(question.subscriptions.first.user).to eq user
  end

  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'commentable'
end
