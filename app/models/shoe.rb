require 'conversion'

class Shoe < ApplicationRecord
  extend Conversion

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

  def self.process_params(input_params)
    processed_params = input_params.deep_dup
    if (input_params[:retire_at_units] == "km")
      processed_params.merge!(retire_at: km_to_miles(input_params[:retire_at].to_f).round)
    end
    processed_params.merge!(category: input_params[:category].to_i)
    processed_params.except(:retire_at_units)
  end

  def self.average_retirement_mileage
    archived.average(:mileage)
  end

  def percent_retire_mileage
    (mileage / retire_at) * 100
  end
end
