module Conversion
  # needed bc want to allow user to input mileage as km, but then store it as miles
  # so this is for conversion of params before storing to the db
  def km_to_miles(km)
    (km / 1.60934)
  end

  # needed bc want to allow user to see mileage in kms
  # this is for taking db info and displaying it in user's preferred units
  def miles_to_km(miles)
    (1.60934 * miles)
  end
end