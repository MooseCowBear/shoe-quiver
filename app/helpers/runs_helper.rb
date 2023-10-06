module RunsHelper
  def duration_display(duration) 
    hours = (duration / 3600).floor
    minutes = (duration / 60).floor % 60
    seconds = duration % 60

    if hours == 0 
      "#{minutes}:#{seconds.to_s.rjust(2, "0")}"
    else
      "#{hours}:#{minutes.to_s.rjust(2, "0")}:#{seconds.to_s.rjust(2, "0")}"
    end
  end
end
