require 'rails_helper'

RSpec.describe "Units", type: :request do
  describe "GET /update" do
    it "returns http success" do
      get "/units/update"
      expect(response).to have_http_status(:success)
    end
  end

end
