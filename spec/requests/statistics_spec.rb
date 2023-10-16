require 'rails_helper'

RSpec.describe "Statistics", type: :request do
  describe "GET /statistics" do
    it "returns http success if user signed in" do
      @user = create(:user)
      sign_in @user
      get "/statistics" 
      expect(response).to have_http_status(:success)
    end

    it "redirects if user not signed in" do
      get "/statistics" 
      expect(response).to have_http_status(302)
    end
  end
end
