require 'rails_helper'

RSpec.describe 'Shoes', type: :system, js: true do
  before do 
    @user = create(:user)
    sign_in @user
  end

  context 'when visiting index page' do
    before do
      @shoe1 = create(:shoe, user: @user, brand: "no runs", mileage: 0, last_run_in: nil)
      shoe2 = create(:shoe, :race_shoe, user: @user, brand: "race shoe", last_run_in: 1.day.ago)
      build(:run, user: @user, shoe: shoe2, date: 1.day.ago)
      shoe3 = create(:shoe, :speed_shoe, user: @user, brand: "speed shoe", last_run_in: 2.days.ago)
      build(:run, user: @user, shoe: shoe3, date: 2.days.ago)
      shoe4 = create(:shoe, :retired, user: @user, brand: "retired shoe")

      visit shoes_path
    end

    it 'displays only non-retired shoes' do
      expect(page).not_to have_content 'retired shoe'
    end

    it 'displays shoes in order of last run in' do
      expect("speed shoe").to appear_before("race shoe")
    end

    it 'displays never run in shoes before shoes that have been run in' do
      expect("no runs").to appear_before("speed shoe")
    end

    it 'creates a new shoe and adds it to the top of shoes' do
      click_on "Add a shoe"
      fill_in "Brand", with: "New Shoe"
      fill_in "Model", with: "New Model"
      fill_in "Color", with: "purple"
      click_button "Create Shoe"

      expect(page).to have_content(/New Shoe/i)
    end

    it 'creates a new run for shoe and sorts shoes to maintain order' do
      click_link(href: "/shoes/#{@shoe1.id}/runs/new")
      fill_in "Date:", with: Date.today
      fill_in "Distance:", with: 4
      fill_in "Minutes:", with: 40
      click_button "Create Run"

      expect("speed shoe").to appear_before("no runs")
    end

    context 'it filters shoes by category' do
      it 'shows only daily trainers' do
        click_on "Daily Trainers"
        expect(page).to have_content(/no runs/i)
      end

      it 'shows only speed shoes' do
        click_on "Speed"
        expect(page).to have_content(/speed shoe/i)
      end

      it 'shows only race shoes' do
        click_on "Race"
        expect(page).to have_content(/race shoe/i)
      end
    end

    it 'switches units' do
      click_on 'Switch to KM'
      expect(page).to have_content(/switch to mi/i)

      click_on 'Switch to Mi'
      expect(page).to have_content(/switch to km/i)
    end
  end

  context 'when visiting show page' do
    before do
      @shoe = create(:shoe, user: @user, brand: "test shoe")
      @run1 = create(:run, user: @user, shoe: @shoe, distance: 5, duration: 40, date: 1.day.ago)
      create(:run, user: @user, shoe: @shoe, distance: 10, duration: 160, date: 2.days.ago)

      visit shoe_path(@shoe)
    end

    it 'displays shoe runs in reverse chronological order by run date' do
      expect("5").to appear_before("10")
    end

    it 'creates a new run for shoe' do
      click_link(href: "/shoes/#{@shoe.id}/runs/new")
      fill_in "Date:", with: Date.today
      fill_in "Distance:", with: 2
      fill_in "Minutes:", with: 20
      click_button "Create Run"

      expect("2").to appear_before("5")
    end

    it 'updates a run' do
      click_link(href: "/runs/#{@run1.id}/edit")
      fill_in "Distance", with: 20
      click_button "Update Run"

      expect(page).to have_content("20")
    end

    it 'redirects after a shoe is retired' do
      click_on "Retire"

      expect has_current_path?(archive_index_path)
    end

    it 'destroys shoe' do
      accept_confirm do
        click_on "Delete"
      end
      
      expect has_current_path?(root_path)
      expect(page).not_to have_content("test shoe")
    end
  end
end