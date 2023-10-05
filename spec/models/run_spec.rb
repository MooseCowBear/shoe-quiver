require 'rails_helper'

RSpec.describe Run, type: :model do
  before(:each) do
    @user = create(:user)
    @shoe = create(:shoe, user: @user)
  end

  it "is valid when it has a duration, distance, and date" do
    run = build(:run, user: @user, shoe: @shoe)
    expect(run).to be_valid
  end

  it "is invalid when no duration" do
    run = build(:run, duration: nil, user: @user, shoe: @shoe)
    expect(run).not_to be_valid
  end

  it "is invalid when no date" do
    run = build(:run, date: nil, user: @user, shoe: @shoe)
    expect(run).not_to be_valid
  end

  it "is invalid when no distance" do
    run = build(:run, distance: nil, user: @user, shoe: @shoe)
    expect(run).not_to be_valid
  end
end
