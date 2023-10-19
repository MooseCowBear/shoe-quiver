require 'rails_helper'

RSpec.describe "DemoSessions", type: :request do
  before (:each) do
    @user = create(:user, email: "alice@fake.com")
  end

  describe "POST /create" do
    it "returns http success" do
      post demo_sessions_path
      expect(response).to redirect_to(root_path)
    end
  end
end
