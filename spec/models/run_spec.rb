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

    context("create new run") do
      it "adds mileage to shoe when it is created" do
        run2 = create(:run, distance: 10, user: @user, shoe: @shoe1)
        @shoe1.reload
        expect(@shoe1.mileage).to eq(15)
      end

      it "updates last run in date of shoe to date of newly created run if no curr date" do
        shoe2 = create(:shoe, user: @user)
        run = create(:run, distance: 2, user: @user, shoe: shoe2)
        shoe2.reload
        expect(shoe2.last_run_in).not_to eq(nil)
      end

      it "updates last run in date of shoe to date of new run if run date > last run date" do
        test_date = Date.today
        run = run2 = create(:run, distance: 10, date: test_date, user: @user, shoe: @shoe1)
        @shoe1.reload
        expect(@shoe1.last_run_in).to eq(test_date)
      end

      it "does not update last run in date if last run in date > new run date" do
        test_date = 4.days.ago.to_date
        run = run2 = create(:run, distance: 10, date: test_date, user: @user, shoe: @shoe1)
        @shoe1.reload
        expect(@shoe1.last_run_in).not_to eq(test_date)
      end
    end

    context("destroy run") do
      it "subtracts mileage from shoe when it is destroyed" do
        @run1.destroy
        @shoe1.reload
        expect(@shoe1.mileage).to eq(0)
      end

      it "updates last run in date of shoe when run is destroyed to shoe's new last run" do
        test_date = 4.days.ago.to_date
        run2 = create(:run, distance: 10, date: test_date, user: @user, shoe: @shoe1)
        @run1.destroy
        @shoe1.reload
        expect(@shoe1.last_run_in).to eq(test_date)
      end

      it "updates last run in date to nil if shoe has no runs after destroy" do
         @run1.destroy
        @shoe1.reload
        expect(@shoe1.last_run_in).to eq(nil)
      end
    end

    context("update run") do
      it "updates mileage to shoe when its distance is updated" do
        @run1.update(distance: 10)
        @shoe1.reload
        expect(@shoe1.mileage).to eq(10)
      end

      it "updates last run in date if change to to date of last run" do
        test_date = 3.days.ago.to_date
        @run1.update(date: test_date)
        @shoe1.reload
        expect(@shoe1.last_run_in).to eq(test_date)
      end

      it "does not update last run in date if date of last run is unchanged" do
         @run1.update(distance: 10)
        @shoe1.reload
        expect(@shoe1.last_run_in).to eq(1.day.ago.to_date)
      end
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
