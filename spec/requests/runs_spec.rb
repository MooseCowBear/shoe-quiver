require 'rails_helper'

RSpec.describe "Runs", type: :request do
  before(:each) do
    @user = create(:user)
    sign_in @user
    @shoe = create(:shoe, user: @user)
    @run = create(:run, user: @user, shoe: @shoe)
    @user2 = create(:user, email: "other@test.com")
    @shoe2 = create(:shoe, user: @user2)
    @run2 = create(:run, user: @user2, shoe: @shoe2)
  end

  describe "GET /index" do
    it "returns http success" do
      get runs_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_shoe_run_path(@shoe) 
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a run" do
      expect {
        post shoe_runs_path(shoe_id: @shoe), params: {
          run: { hours: 0, minutes: 20, seconds: 0, distance: 2, date: 1.day.ago, distance_units: "mi", notes: "", felt: 1, referrer: "shoe" }
        }
      }.to change(Run, :count).by(1)
    end

    it 'returns a turbo stream response' do
      post shoe_runs_path(shoe_id: @shoe), 
        params: {
          run: { hours: 0, minutes: 20, seconds: 0, distance: 2, date: 1.day.ago, distance_units: "mi", notes: "", felt: 1, referrer: "shoe" }
        }, 
        as: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  describe "GET /edit" do
    it "returns http success when run belongs to user" do
      get edit_run_path(@run) 
      expect(response).to have_http_status(:success)
    end

    it "redirects when run does not belong to user" do
      get edit_run_path(@run2)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /update" do
    it "returns http success when run belongs to user" do
      patch run_path(@run), params: {
          run: { hours: 0, minutes: 20, seconds: 0, distance: 2, date: 1.day.ago, distance_units: "mi", notes: "", felt: 1, referrer: "shoe" }
        }
      expect(response).to redirect_to(shoe_path(@shoe))
    end

    it "redirects when run does not belong to user" do
      patch run_path(@run2), params: {
          run: { hours: 0, minutes: 20, seconds: 0, distance: 2, date: 1.day.ago, distance_units: "mi", notes: "", felt: 1, referrer: "shoe" }
        }
      expect(response).to redirect_to(root_path)
    end

    it 'returns a turbo stream response after updated by user' do
      patch run_path(@run), 
        params: {
          run: { hours: 0, minutes: 20, seconds: 0, distance: 2, date: 1.day.ago, distance_units: "mi", notes: "", felt: 1, referrer: "shoe" }
        }, 
        as: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  describe "DELETE /destroy" do
    it "destroys run when run belongs to user" do
      expect {
        delete run_path(@run)
      }.to change(Run, :count).by(-1)
    end

    it "redirects when run does not belong to user" do
      delete run_path(@run2)
      expect(response).to redirect_to(root_path)
    end

    it 'returns a turbo stream response when user destroys run' do
      delete run_path(@run), as: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end
end
