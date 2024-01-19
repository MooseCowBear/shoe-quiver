require 'rails_helper'

RSpec.describe 'User sign in', type: :system do
  subject { new_user_session_path }

  before do
    visit subject
  end

  context "when user is invalid" do
    it "shows invalid credentials alert" do
      fill_in "Email", with: 'invalid_email@test.com'
      fill_in "Password", with: 'invalid_password'
      click_button "Log in"

      expect(page).to have_content('Invalid Email or password.')
    end
  end

  context "when user is valid" do
    it 'redirects to shoe index' do
      user = create(:user)
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"

      expect has_current_path?(shoes_path)
    end
  end
end