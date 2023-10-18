require 'rails_helper'

RSpec.describe "DemoSessions", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/demo_sessions/create"
      expect(response).to have_http_status(:success)
    end
  end

end
