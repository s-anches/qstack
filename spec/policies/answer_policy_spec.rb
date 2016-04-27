require 'rails_helper'

describe AnswerPolicy do
  subject { AnswerPolicy.new(user, answer) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  context "for a guest" do
    let(:user) { nil }

    context 'list of answers' do
      let(:answer) { create_list(:answer, 5, question: question) }
      it { should permit_action(:index)   }
    end
    it { should permit_action(:show)    }

    it { should forbid_action(:new)     }
    it { should forbid_action(:create)  }
    it { should forbid_action(:update)  }
    it { should forbid_action(:destroy) }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it { should permit_action(:index)   }
    it { should permit_action(:show)    }
    it { should permit_action(:new)     }
    it { should permit_action(:create)  }

    context 'his answer' do
      let(:answer) { create(:answer, user: user) }

      it { should permit_action(:update)  }
      it { should permit_action(:destroy) }
    end

    context 'foreign answer' do
      it { should forbid_action(:update)  }
      it { should forbid_action(:destroy) }
    end

    context 'his question' do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question) }
      it { should permit_action(:set_best) }
    end

    context 'foreign question' do
      let(:answer) { create(:answer, question: question) }
      it { should forbid_action(:set_best) }
    end
  end

  context 'for a admin' do
    let(:user) { create(:user, admin: true)}

    it { should permit_action(:index)   }
    it { should permit_action(:show)    }
    it { should permit_action(:new)     }
    it { should permit_action(:create)  }
    it { should permit_action(:update)  }
    it { should permit_action(:destroy) }
  end
end
