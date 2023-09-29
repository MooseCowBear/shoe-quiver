class Shoe < ApplicationRecord
  enum :category, [:daily_trainer, :speed, :race]

  validates_presence_of :brand, :model

  scope :current, -> { where(retired_on: nil) }
  scope :archived, -> { where.not(retired_on: nil) }

  scope :daily_trainers, -> { where(category: :daily_trainer) }
  scope :speed, -> { where(category: :speed) }
  scope :race, -> { where(category: :race) }
end
