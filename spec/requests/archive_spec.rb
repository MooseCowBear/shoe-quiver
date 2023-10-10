require 'rails_helper'

RSpec.describe "Archives", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/archive/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/archive/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/archive/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
