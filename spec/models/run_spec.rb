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

  describe("callbacks") do
    before(:each) do
      @shoe1 = create(:shoe, mileage: 0, user: @user)
      @run1 = create(:run, distance: 5, user: @user, shoe: @shoe1)
    end

    it "adds mileage to shoe when it is created" do
      @run2 = create(:run, distance: 10, user: @user, shoe: @shoe1)
      @shoe1.reload
      expect(@shoe1.mileage).to eq(15)
    end

    it "subtracts mileage from shoe when it is destroyed" do
      @run1.destroy
      @shoe1.reload
      expect(@shoe1.mileage).to eq(0)
    end

    it "updates mileage to shoe when its distance is updated" do
      @run1.update(distance: 10)
      @shoe1.reload
      expect(@shoe1.mileage).to eq(10)
    end
  end

  describe(".order_by_date") do
    it "sorts so most recent run is last" do
      shoe1 = create(:shoe, user: @user)
      run1 = create(:run, distance: 10, date: 3.days.ago, user: @user, shoe: shoe1)
      run2 = create(:run, distance: 5, date: 1.day.ago, user: @user, shoe: shoe1)

      expect(Run.order_by_date.last.distance).to eq(5)
    end
  end
end
