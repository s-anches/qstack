require 'rails_helper'

describe VotePolicy do
  subject { VotePolicy.new(user, question) }

  let(:question) { create(:question) }

  context "for a guest" do
    let(:user) { nil }

    it { should forbid_action(:can_vote) }
    it { should forbid_action(:unvote)   }
  end

  context "for a user" do
    let(:user) { create(:user) }

    context 'his question' do
      let(:question) { create(:question, user: user) }

      it { should forbit_action(:can_vote) }
      it { should forbit_action(:unvote)   }
    end

    context 'foreign question not voted' do
      it { should permit_action(:can_vote) }
      it { should forbit_action(:unvote)   }
    end

    context 'foreign question voted' do
      let(:vote) { create(:vote, user: user, votable: question) }
      it { should forbit_action(:can_vote) }
      it { should permit_action(:unvote)   }
    end
  end
end
