class Shoe < ApplicationRecord
  enum :category, [:daily_trainer, :speed, :race]
end
