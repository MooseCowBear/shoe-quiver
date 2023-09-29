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
end