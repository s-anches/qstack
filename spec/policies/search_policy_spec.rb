require 'rails_helper'

RSpec.describe SearchPolicy do
  subject { described_class }

  context "for a guest" do
    
    it { should permit_action(:search) }
  end
end
