module RunsHelper
  def duration_display(duration) 
    duration = duration.round
    hours = (duration / 3600).floor
    minutes = (duration / 60).floor % 60
    seconds = duration % 60

    if hours == 0 
      "#{minutes}:#{seconds.to_s.rjust(2, "0")}"
    else
      "#{hours}:#{minutes.to_s.rjust(2, "0")}:#{seconds.to_s.rjust(2, "0")}"
    end
  end

  def distance_display(mileage, unit)
    # todo: make responsive to preferences
    "#{mileage.round(2).to_s} #{unit}"
  end

  def pace_display(mileage, duration, unit)
    #todo: convert from miles to km if unit is km
    "#{duration_display(duration / mileage)} / #{unit}"
  end

  def feel_category(run)
    return "" if run.new_record?
    case run.felt
    when "good"
      "bg-mint text-neutral-50"
    when "okay"
      "bg-mustard"
    when "bad"
      "bg-poppy text-neutral-50"
    else
      "bg-neutral-200"
    end
  end
end
