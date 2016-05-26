require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #search" do
    it "calls Find" do
      expect(Search).to receive(:find).with("123", "all", "2")
      get :search, query: "123", scope: "all", page: "2"
    end
  end
end
