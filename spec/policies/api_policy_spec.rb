require 'rails_helper'

describe ApiPolicy do
  subject { ApiPolicy.new(user) }

  context "for a guest" do
    let(:user) { nil }
    
    it { should forbid_action(:index) }
    it { should forbid_action(:me) }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it { should permit_action(:index)   }
    it { should permit_action(:me)      }
  end
end
