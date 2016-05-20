require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe '.new_answer' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: other_user) }
    let!(:mail) { described_class.new_answer(user, question, answer).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer for you question #{question.title}!")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded)
        .to include(question.title)
      expect(mail.body.encoded)
        .to include(question_url(question.id))
      expect(mail.body.encoded)
        .to include(answer.body)
      expect(mail.body.encoded)
        .to include(other_user.email)
    end
  end
end
