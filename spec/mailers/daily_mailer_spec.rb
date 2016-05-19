require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  let!(:user) { create(:user) }

  describe ".digest" do
    let!(:questions) { create_list(:question, 3)}
    let!(:mail) { described_class.digest(user, questions).deliver_now }

    it "renders the headers" do
      expect(mail.subject).to eq("Every day digest!")
      expect(mail.to).to eq([user.email])
    end

    shared_examples_for "body rendering" do |part|
      it "renders the #{part.to_s}" do
        questions.each do |question|
          expect(mail.body.encoded)
            .to include(question.title)
          expect(mail.body.encoded)
            .to include(question_url(question.id))
        end
      end
    end

    it_behaves_like "body rendering", :text_part
    it_behaves_like "body rendering", :html_part
  end
end
