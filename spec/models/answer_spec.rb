require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should have_many :attachments }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answer_best) { create(:answer, question: question, best: true) }

  describe 'default scope' do
    it 'return best answer first' do
      expect(question.reload.answers).to eq ([answer_best, answer])
    end
  end

  describe '#set_best method' do
    it 'set answer best' do
      expect(answer.best?).to eq false

      answer.set_best

      expect(answer.best?).to eq true
    end

    it 'set old best answer to false' do
      expect(answer_best.best).to eq true

      answer.set_best
      answer_best.reload

      expect(answer_best.best?).to eq false
      expect(answer.best?).to eq true
    end
  end
end
