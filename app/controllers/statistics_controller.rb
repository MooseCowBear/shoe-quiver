class StatisticsController < ApplicationController
  def index
    @this_year = current_user.runs.recent_average_mileage(Run.method(:from_year))
    @this_month = current_user.runs.recent_average_mileage(Run.method(:from_month))
    @this_week = current_user.runs.recent_average_mileage(Run.method(:from_week))
    @avg_distance = current_user.runs.average_distance
    @avg_duration = current_user.runs.average_duration
    @avg_retirement_mileage = current_user.shoes.average_retirement_mileage
  end
end
