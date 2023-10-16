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
    if unit == "mi"
      "#{mileage.round(2).to_s} #{unit}"
    else 
      "#{miles_to_km(mileage).round(2).to_s} #{unit}"
    end
  end

  def pace_display(mileage, duration, unit)
    if unit == "mi"
      "#{duration_display(duration / mileage)} / #{unit}"
    else
      "#{duration_display(duration / miles_to_km(mileage))} / #{unit}"
    end
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
