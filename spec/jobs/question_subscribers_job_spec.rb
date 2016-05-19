require 'rails_helper'

RSpec.describe QuestionSubscribersJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends new answer notification' do
    expect(NotificationsMailer).to receive(:new_answer).with(question, answer).and_call_original

    QuestionSubscribersJob.perform_now(question, answer)
  end
end
