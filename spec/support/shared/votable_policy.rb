shared_examples_for 'Policy Votable' do
  subject { described_class.new(user, model) }

  let(:klass) { described_class.to_s.underscore[/[a-zA-Z]+/] }
  let(:model) { create (klass) }

  context 'for a guest' do
    let(:user) { nil }

    it { should forbid_action(:can_vote) }
    it { should forbid_action(:unvote)   }
  end

  context 'for a user' do
    let(:user) { create(:user) }

    context "his model"  do
      let (:model) { create(klass, user: user) }
      it { should forbid_action(:can_vote) }
      it { should forbid_action(:unvote)   }
    end

    context 'foreign model' do
      context 'not voted' do
        it { should permit_action(:can_vote) }
        it { should forbid_action(:unvote)   }
      end

      context 'voted' do
        let!(:vote) { create(:vote, user: user, votable: model) }
        it { should forbid_action(:can_vote) }
        it { should permit_action(:unvote)   }
      end
    end
  end
end