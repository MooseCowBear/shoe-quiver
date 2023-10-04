class Shoe < ApplicationRecord
  belongs_to :user 
  
  enum :category, { daily_trainer: 0, speed: 1, race: 2 }

  validates_presence_of :brand, :model

  scope :current, -> { where(retired_on: nil) }
  scope :archived, -> { where.not(retired_on: nil) }

  scope :daily_trainers, -> { where(category: :daily_trainer) }
  scope :speed, -> { where(category: :speed) }
  scope :race, -> { where(category: :race) }

  def percent_retire_mileage
    (mileage / retire_at) * 100
  end
end
