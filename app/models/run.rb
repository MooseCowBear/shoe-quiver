class Run < ApplicationRecord
  belongs_to :user
  belongs_to :shoe

  enum :felt, { unspecified: 0, good: 1, okay: 2, bad: 3 }

  validates_presence_of :distance, :duration, :date
end
