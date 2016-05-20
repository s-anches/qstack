require 'rails_helper'

RSpec.describe QuestionSubscribersJob, type: :job do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question, user: users.first) }
  let!(:answer) { create(:answer, question: question) }
  before(:each) { users.each {|user| user.subscribe(question)} }

  it 'sends new answer notification for subscribers' do
    users.each do |user|
      expect(NotificationsMailer).to receive(:new_answer).with(user, question, answer).and_call_original
    end

    QuestionSubscribersJob.perform_now(question, answer)
  end
end
