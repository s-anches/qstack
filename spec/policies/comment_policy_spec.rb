require 'rails_helper'

describe CommentPolicy do
  subject { CommentPolicy.new(user, comment) }

  let(:comment) { create(:comment) }

  context "for a guest" do
    let(:user) { nil }

    context 'list of comments' do
      let(:comment) { create_list(:comment, 5) }
      it { should permit_action(:index)   }
    end
    it { should permit_action(:show)    }

    it { should forbid_action(:new)     }
    it { should forbid_action(:create)  }
    it { should forbid_action(:destroy) }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it { should permit_action(:index)   }
    it { should permit_action(:show)    }
    it { should permit_action(:new)     }
    it { should permit_action(:create)  }

    context 'his comment' do
      let(:comment) { create(:comment, user: user) }

      it { should permit_action(:destroy) }
    end

    context 'foreign comment' do
      it { should forbid_action(:destroy) }
    end
  end

  context 'for a admin' do
    let(:user) { create(:user, admin: true)}

    it { should permit_action(:index)   }
    it { should permit_action(:show)    }
    it { should permit_action(:new)     }
    it { should permit_action(:create)  }
    it { should permit_action(:destroy) }
  end
end
