require 'rails_helper'

RSpec.describe "Shoes", type: :request do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user, email: "other@test.com")
  end

  describe "GET /new" do
    it "returns http success" do
      sign_in @user1
      get "/shoes/new"
      expect(response).to have_http_status(:success)
    end
  end 

  describe "POST /create" do
    before(:each) do
      sign_in @user1
    end

    context "with valid params" do
      it "creates a shoe" do
        expect {
          post shoes_path, params: {
            shoe: { brand: "Saucony", model: "Triumph 21" }
          }
        }.to change(Shoe, :count).by(1)
      end

      it 'returns a turbo stream response' do
        post shoes_path, 
          params: {
            shoe: { brand: "Saucony", model: "Triumph 21" }
          }, 
          as: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context "with invalid params" do
      it "does not create a shoe" do
        expect {
          post shoes_path, params: {
            shoe: { brand: "Saucony" }
          }
        }.to change(Shoe, :count).by(0)
      end
    end
  end

  describe "POST /update" do
    before(:each) do
      sign_in @user1
    end

    context "when params are valid" do
      it "updates" do
        shoe = create(:shoe, user: @user1)
        patch shoe_path(shoe), params: { shoe: { brand: "Brooks", model: "Ghost" } }
        shoe.reload
        expect(shoe.brand).to eq("Brooks")
      end

      it 'returns a turbo stream response' do
        shoe = create(:shoe, user: @user1)
        patch shoe_path(shoe), 
          params: { shoe: { brand: "Brooks", model: "Ghost" } }, 
          as: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context "when params are invalid" do
      it "does not update" do
        shoe = create(:shoe, user: @user1)
        patch shoe_path(shoe), params: { shoe: { brand: "Brooks", model: "" } }
        shoe.reload
        expect(shoe.brand).to eq("saucony")
      end
    end
  end

  describe "GET /edit" do
    before(:each) do
      sign_in @user1
    end

    context "when shoe belongs to user" do
      it "returns http success" do
        shoe = create(:shoe, user: @user1)
        get edit_shoe_path(shoe)
        expect(response).to have_http_status(:success)
      end
    end

    context "when shoe does not belong to user" do
      it "redirects to root" do
        shoe = create(:shoe, user: @user2)
        get edit_shoe_path(shoe)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /destroy" do
    before(:each) do
      sign_in @user1
    end

    context "when user is signed in and shoe belongs to user" do
      it "destroys shoe" do
        shoe = create(:shoe, user: @user1)
        expect {
          delete shoe_path(shoe)
        }.to change(Shoe, :count).by(-1)
      end
    end

    context "when user is signed in but shoe does not belong to user" do
      it "does not destroy shoe" do
        shoe = create(:shoe, user: @user2)
        expect {
          delete shoe_path(shoe)
        }.to change(Shoe, :count).by(0)
      end

      it "redirects to root" do
        shoe = create(:shoe, user: @user2)
        delete shoe_path(shoe)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /index" do
    context "when user is signed in" do
      it "returns http success" do
        sign_in @user1
        get shoes_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when no user signed in" do
      it "redirects to sign in page" do
        get shoes_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /show" do
    before(:each) do
      sign_in @user1
    end

    context "when user is signed in and shoe belongs to user" do
      it "returns http success" do
        shoe = create(:shoe, user: @user1)
        get shoe_path(shoe)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user us signed in and shoe does not belong to user" do
      it "redirects to root" do
        shoe = create(:shoe, user: @user2)
        get shoe_path(shoe)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
