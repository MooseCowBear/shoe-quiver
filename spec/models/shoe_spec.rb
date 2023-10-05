require 'rails_helper'

RSpec.describe Shoe, type: :model do
  it "is valid when it has a brand and a model" do
    user = create(:user)
    shoe = build(:shoe, user: user)
    expect(shoe).to be_valid
  end

  it "is not valid without a brand" do
    user = create(:user)
    shoe = build(:shoe, brand: "", user: user)
    expect(shoe).not_to be_valid
  end

  it "is not valid without a model" do
    user = create(:user)
    shoe = build(:shoe, model: "", user: user)
    expect(shoe).not_to be_valid
  end

  describe ".current" do
    before(:each) do
      user = create(:user)
      @retired_shoe = create(:shoe, :retired, user: user)
      @not_retired_shoe = create(:shoe, user: user)
    end

    it "returns non-retired shoes" do
      expect(Shoe.current).to include(@not_retired_shoe)
    end

    it "does not return retired shoes" do
      expect(Shoe.current).not_to include(@retired_shoe)
    end
  end

  describe ".archived" do
    before(:each) do
      user = create(:user)
      @retired_shoe = create(:shoe, :retired, user: user)
      @not_retired_shoe = create(:shoe, user: user)
    end

    it "returns retired shoes" do
      expect(Shoe.archived).to include(@retired_shoe)
    end

    it "does not return non-retired shoes" do
      expect(Shoe.archived).not_to include(@not_retired_shoe)
    end
  end

  describe ".daily_trainers" do
    before(:each) do
      user = create(:user)
      @trainer = create(:shoe, user: user)
      @speed = create(:shoe, :speed_shoe, user: user)
      @race = create(:shoe, :race_shoe, user: user)
    end

    it "returns shoes with category of daily trainer" do
      expect(Shoe.daily_trainers).to include(@trainer)
    end

    it "does not return shoes with category speed" do
      expect(Shoe.daily_trainers).not_to include(@speed)
    end

    it "does not return shoes with category race" do
      expect(Shoe.daily_trainers).not_to include(@race)
    end
  end

  describe ".speed" do
    before(:each) do
      user = create(:user)
      @trainer = create(:shoe, user: user)
      @speed = create(:shoe, :speed_shoe, user: user)
      @race = create(:shoe, :race_shoe, user: user)
    end

    it "returns shoes with category of speed" do
      expect(Shoe.speed).to include(@speed)
    end

    it "does not return shoes with category of daily trainer" do
      expect(Shoe.speed).not_to include(@trainer)
    end

    it "does not return shoes with category of race" do
      expect(Shoe.speed).not_to include(@race)
    end
  end

  describe ".race" do
    before(:each) do
      user = create(:user)
      @trainer = create(:shoe, user: user)
      @speed = create(:shoe, :speed_shoe, user: user)
      @race = create(:shoe, :race_shoe, user: user)
    end

    it "returns shoes with category of race" do
      expect(Shoe.race).to include(@race)
    end

    it "does not return shoes with category of daily trainer" do
      expect(Shoe.race).not_to include(@trainer)
    end

    it "does not return shoes with category of speed" do 
      expect(Shoe.race).not_to include(@speed)
    end
  end

  describe ".order_by_last_run" do
    before(:each) do
      @user = create(:user)
      @shoe1 = create(:shoe, last_run_in: 1.day.ago, user: @user)
      @shoe2 = create(:shoe, last_run_in: 2.days.ago, user: @user)
    end

    it "returns shoes that have been run in reverse order of last run" do
      res = Shoe.order_by_last_run
      expect(res[0].last_run_in).to be < res[1].last_run_in
    end

    it "returns shoes that have never been run in before shoes that have been" do
      shoe3 = create(:shoe, user: @user)
      res = Shoe.order_by_last_run
      expect(res[0].last_run_in).to eq(nil)
    end
  end

  describe ".order_by_creation" do
    it "returns shoes with most recently created first" do
      user = create(:user)
      shoe1 = create(:shoe, created_at: 2.days.ago, user: user)
      shoe2 = create(:shoe, created_at: 1.day.ago, user: user)
      res = Shoe.order_by_creation
      expect(res[0].created_at).to be > res[1].created_at
    end
  end
end