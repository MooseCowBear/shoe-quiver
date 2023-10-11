require 'rails_helper'

RSpec.describe "Statistics", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/statistics/show"
      expect(response).to have_http_status(:success)
    end
  end

end
