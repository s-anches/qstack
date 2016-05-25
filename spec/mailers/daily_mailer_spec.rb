require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  let!(:user) { create(:user) }

  describe ".digest" do
    let!(:questions) { create_list(:question, 3)}
    let!(:mail) { described_class.digest(user).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Every day digest!")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      questions.each do |question|
        expect(mail.body.encoded)
          .to include(question.title)
        expect(mail.body.encoded)
          .to include(question_url(question.id))
      end
    end
  end
end
