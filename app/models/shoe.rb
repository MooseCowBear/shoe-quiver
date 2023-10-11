class Shoe < ApplicationRecord
  belongs_to :user 
  has_many :runs, dependent: :nullify
  
  enum :category, { daily_trainer: 0, speed: 1, race: 2 }

  validates_presence_of :brand, :model

  scope :current, -> { where(retired_on: nil) }
  scope :archived, -> { where.not(retired_on: nil) }

  scope :daily_trainers, -> { where(category: :daily_trainer) }
  scope :speed, -> { where(category: :speed) }
  scope :race, -> { where(category: :race) }

  scope :order_by_last_run, -> { order('last_run_in ASC NULLS FIRST' ) }
  scope :order_by_creation, -> { order(created_at: :desc) }
  scope :order_by_retirement, -> { order(retired_on: :desc) }

  # not right... ideally, want rate of mileage accumulation up to retirement if retired
  # else up to now. but even this might bias a shoe you ran one long run in today...
  def self.top_by_mileage_accumulation
    order(Arel.sql('mileage / (now() - created_at) desc')).limit(3) 
  end

  def self.average_retirement_mileage
    archived.average(:mileage)
  end

  def percent_retire_mileage
    (mileage / retire_at) * 100
  end
end
