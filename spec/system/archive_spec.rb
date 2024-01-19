require 'rails_helper'

RSpec.describe 'Archive', type: :system, js: true do
  before do 
    @user = create(:user)
    sign_in @user

    @shoe1 = create(:shoe, :retired, user: @user, brand: "retired shoe", retired_on: 1.week.ago)
    @shoe2 = create(:shoe, :retired, user: @user, brand: "second retired shoe", retired_on: 2.days.ago)

    visit archive_index_path
  end

  it "lists all the shoes in reverse order of retired on date" do
    expect("second retired shoe").to appear_before("retired shoe")
  end

  it "unretires a shoe" do
    click_on("Unretire", match: :first)

    expect(page).to have_current_path(root_path)
    expect(page).to have_content(/second retired shoe/i)
  end

  it "destroys a shoe" do
    accept_confirm do
      within("main") do
        find(:button, type: 'submit', match: :first).click
      end
    end

    expect(page).not_to have_content(/second retired shoe/i)
  end
end