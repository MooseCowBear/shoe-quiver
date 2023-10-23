require 'conversion'

class Run < ApplicationRecord
  extend Conversion

  belongs_to :user
  belongs_to :shoe, optional: true

  enum :felt, { unspecified: 0, good: 1, okay: 2, bad: 3 }

  validates_presence_of :distance, :duration, :date

  before_create :add_shoe_mileage
  before_destroy :subtract_shoe_mileage
  before_update :update_shoe_milage
  before_commit :update_shoe_last_run

  scope :order_by_date, -> { order(date: :asc) }
  scope :reverse_order_by_date, -> { order(date: :desc) } #most recent runs first

  scope :from_year, ->(date) { where(date: date.beginning_of_year..date.end_of_year) }
  scope :from_month, ->(date) { where(date: date.beginning_of_month..date.end_of_month) }
  scope :from_week, ->(date) { where(date: date.beginning_of_week..date.end_of_week) }

  def self.recent_mileage(recent_scope)
    recent_scope.call(Date.current).sum(:distance)
  end

  def self.average_distance
    average(:distance)
  end

  def self.average_duration
    average(:duration)
  end

  def self.process_params(input_params)
    processed_params = input_params.deep_dup
    if (input_params[:distance_units] == "km")
      processed_params.merge!(distance: km_to_miles(input_params[:distance].to_f))
    end
    duration_in_seconds = processed_params[:hours].to_i * 60 * 60 + processed_params[:minutes].to_i * 60 + processed_params[:seconds].to_i
    processed_params.merge!(duration: duration_in_seconds, felt: input_params[:felt].to_i)
    processed_params.except(:hours, :minutes, :seconds, :distance_units)
  end

  private 

  #after create 
  def add_shoe_mileage 
    return unless shoe
    old_mileage = shoe.mileage
    shoe.update(mileage: old_mileage + distance)
  end

  #after destroy 
  def subtract_shoe_mileage
    return unless shoe
    old_mileage = shoe.mileage
    shoe.update(mileage: old_mileage - distance)
  end

  #before update
  def update_shoe_milage
    return unless shoe
    if distance_was != distance
      old_mileage = shoe.mileage
      new_mileage = old_mileage - distance_was + distance
      shoe.update(mileage: new_mileage)
    end
  end

  def update_shoe_last_run
    # after change to shoe runs, need to update date 
    return unless shoe
    last_run = shoe.runs.order_by_date.last
    prev_date = last_run ? last_run.date : nil
    shoe.update(last_run_in: prev_date)
  end
end
