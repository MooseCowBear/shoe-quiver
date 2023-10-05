class Run < ApplicationRecord
  belongs_to :user
  belongs_to :shoe

  enum :felt, { unspecified: 0, good: 1, okay: 2, bad: 3 }

  validates_presence_of :distance, :duration, :date

  after_create :add_shoe_mileage
  after_create :update_shoe_last_run
  after_destroy :subtract_shoe_mileage
  before_update :update_shoe_milage
  after_update :update_shoe_last_run

  private 

  #after create 
  def add_shoe_mileage 
    old_mileage = shoe.mileage
    shoe.update(mileage: old_mileage + distance)
  end

  def update_shoe_last_run
    shoe.update(last_run_in: self.date)
  end

  #after destroy 
  def subtract_shoe_mileage
    old_mileage = shoe.mileage
    shoe.update(mileage: old_mileage - distance)
  end

  #before update
  def update_shoe_milage
    if distance_was != distance
      old_mileage = shoe.mileage
      new_mileage = old_mileage - distance_was + distance
      shoe.update(mileage: new_mileage)
    end
  end
end
