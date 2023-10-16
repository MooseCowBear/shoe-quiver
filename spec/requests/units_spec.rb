require 'rails_helper'

RSpec.describe "Units", type: :request do
  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  describe "POST /update" do
    it "updates units for user" do
      patch units_path, params: { user: { unit: "km" } }
      @user.reload
      expect(@user.unit).to eq("km")
    end
  end
end
