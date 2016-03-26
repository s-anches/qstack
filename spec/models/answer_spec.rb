require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to(:user) }
  it { should belong_to(:question) }

  let(:answer) { create(:answer) }

  describe '#set_best method' do
    it 'set answer best' do
      expect(answer.best?).to eq false

      answer.set_best

      expect(answer.best?).to eq true
    end

    # it 'set old best answer to false' do
    #   expect(answer_best.best?).to eq true

    #   answer_one.set_best
    #   answer_best.reload

    #   expect(answer_best.best?).to eq false
    #   expect(answer_one.best?).to eq true
    # end
  end
end
