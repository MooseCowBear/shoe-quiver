require 'rails_helper'

RSpec.describe "Archives", type: :request do
  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  describe "GET /index" do
    it "returns http success" do
      get archive_index_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /update" do
    it "returns http success" do
      shoe = create(:shoe, user: @user)
      patch archive_path(shoe.id) 
      shoe.reload
      expect(shoe.retired_on).not_to be(nil)
      expect(response).to redirect_to(archive_index_path)
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      shoe = create(:shoe, user: @user, retired_on: DateTime.now)
      delete archive_path(shoe.id)
      shoe.reload
      expect(shoe.retired_on).to be(nil)
      expect(response).to redirect_to(root_path)
    end
  end

end
