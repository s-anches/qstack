require 'rails_helper'

describe QuestionPolicy do
  subject { QuestionPolicy.new(user, question) }

  let(:question) { create(:question) }

  context "for a guest" do
    let(:user) { nil }

    context 'list of questions' do
      let(:question) { create_list(:question, 5) }
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

    context 'his question' do
      let(:question) { create(:question, user: user) }

      it { should permit_action(:update)  }
      it { should permit_action(:destroy) }
    end

    context 'foreign question' do
      it { should forbid_action(:update)  }
      it { should forbid_action(:destroy) }
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
