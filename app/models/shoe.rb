class Shoe < ApplicationRecord
  enum :category, [:daily_trainer, :speed, :race]

  validates_presence_of :brand, :model
end
