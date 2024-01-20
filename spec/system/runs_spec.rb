require 'rails_helper'

RSpec.describe 'Runs', type: :system, js: true do
  before do 
    @user = create(:user)
    sign_in @user
  end

  # TODO: runs should be in a stimulus ordering controller too
  # to handle the case of someone creating multiple runs but out of order
  # BUT if switch to charts instead of list, then this change will be moot

  context 'when visiting shoe show page' do
    before do
      @shoe = create(:shoe, user: @user)
      @run = create(:run, shoe: @shoe, user: @user)
      visit shoe_path(@shoe)
    end 

    it 'should create a new run' do
      click_link(href: "/shoes/#{@shoe.id}/runs/new")
      fill_in "Date:", with: Date.today
      fill_in "Distance:", with: 2
      fill_in "Minutes:", with: 20
      click_button "Create Run"

      expect(page).to have_content("2")
    end

    it 'should update a run' do
      click_link(href: "/runs/#{@run.id}/edit")
      fill_in "Distance", with: 20
      click_button "Update Run"

      expect(page).to have_content("20")
    end

    it 'should destroy a run' do 
      accept_confirm do
        within("#runs") do
          find(:button, type: 'submit', match: :first).click
        end
      end

      expect(page).not_to have_content("9.99")
    end
  end

  context 'when visiting the runs index page' do
    before do
      @run1 = create(:run, shoe: @shoe, user: @user, date: 1.day.ago, distance: 10)
      @run2 = create(:run, shoe: @shoe, user: @user, date: 1.month.ago, distance: 5)

      visit runs_path
    end

    it "should default to current month's runs" do
      curr_month = Date.today.strftime("%B")

      expect(page).to have_content(/#{curr_month}/i)
      expect(page).to have_content("10.0 mi")
      expect(page).not_to have_content("5.0 mi")
    end

    it "should take you to previous month's runs" do
      prev_month = (Date.today - 1.month).strftime("%B")
     
      within(".simple-calendar") do
        click_on "< Previous"
      end

      expect(page).to have_content(/#{prev_month}/i)
      expect(page).to have_content("5.0 mi")
      expect(page).not_to have_content("10.0 mi")
    end

    it "should take you to next month's runs" do
      next_month = (Date.today + 1.month).strftime("%B")
     
      within(".simple-calendar") do
        click_on "Next >"
      end

      expect(page).to have_content(/#{next_month}/i)
    end

    it 'should redirect to edit run page when clicked' do
      click_link(href: "/runs/#{@run1.id}/edit")

      expect(page).to have_current_path(edit_run_path(@run1))
    end
  end
end