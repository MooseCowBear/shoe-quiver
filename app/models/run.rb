class Run < ApplicationRecord
  belongs_to :user
  belongs_to :shoe

  enum :felt, { unspecified: 0, good: 1, okay: 2, bad: 3 }

  validates_presence_of :distance, :duration, :date

  after_create :add_shoe_mileage
  after_destroy :subtract_shoe_mileage
  before_update :update_shoe_milage
  after_commit :update_shoe_last_run

  scope :order_by_date, -> { order(date: :asc) }

  private 

  #after create 
  def add_shoe_mileage 
    old_mileage = shoe.mileage
    shoe.update(mileage: old_mileage + distance)
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

  def update_shoe_last_run
    # after change to shoe runs, need to update date 
    last_run = shoe.runs.order_by_date.last
    prev_date = last_run ? last_run.date : nil
    shoe.update(last_run_in: prev_date)
  end
end
