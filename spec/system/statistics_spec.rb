require 'rails_helper'

RSpec.describe 'Statistics', type: :system, js: true do
  before do 
    @user = create(:user)
    sign_in @user
  end

  context 'User is new user' do
    it 'should display message if no retired shoes' do
      visit statistics_path

      expect(page).to have_content(/You haven't retired any shoes./i)
    end
  end

  context 'User is not a new user' do
    it 'should display retirement mileage average if retired shoes' do
      shoe1 = create(:shoe, :retired, user: @user, mileage: 50)
      shoe2 = create(:shoe, :retired, user: @user, mileage: 60)

      visit statistics_path

      expect(page).to have_content("55.0 mi")
    end
  end
end