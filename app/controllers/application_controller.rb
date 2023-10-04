class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?

  helper_method :km_to_miles
  helper_method :miles_to_km

  # needed bc want to allow user to input mileage as km, but then store it as miles
  # so this is for conversion of params before storing to the db
  def km_to_miles(km)
    (0.621371 * km)
  end

  # needed bc want to allow user to see mileage in kms
  # this is for taking db info and displaying it in user's preferred units
  def miles_to_km(miles)
    (1.60934 * miles)
  end
end
