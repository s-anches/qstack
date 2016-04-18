require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  let(:user) { create :user }
  let(:answer) { create :answer, user: user}
  let(:other_answer) { create :answer }

  describe 'author_of?' do
    it 'return true if user author of object' do
      expect(user).to be_author_of(answer)
    end
    it 'return false if user not author of object' do
      expect(user).to_not be_author_of(other_answer)
    end
  end
end
