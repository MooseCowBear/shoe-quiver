require 'rails_helper'

RSpec.describe Shoe, type: :model do
  it "is valid when it has a brand and a model" do
    shoe = build(:shoe)
    expect(shoe).to be_valid
  end

  it "is not valid without a brand" do
    shoe = build(:shoe, brand: "")
    expect(shoe).not_to be_valid
  end

  it "is not valid without a model" do
    shoe = build(:shoe, model: "")
    expect(shoe).not_to be_valid
  end

  describe ".current" do
    before(:each) do
      @retired_shoe = create(:shoe, :retired)
      @not_retired_shoe = create(:shoe)
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
      @retired_shoe = create(:shoe, :retired)
      @not_retired_shoe = create(:shoe)
    end

    it "returns retired shoes" do
      expect(Shoe.archived).to include(@retired_shoe)
    end

    it "does not return non-retired shoes" do
      expect(Shoe.archived).not_to include(@not_retired_shoe)
    end
  end
end