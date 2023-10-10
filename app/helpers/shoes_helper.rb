module ShoesHelper
  def category_identifier(shoe)
    # for making little css visuals for shoe type
    case shoe.category
    when "daily_trainer"
      "dt"
    when "speed"
      "s"
    when "race"
      "r"
    end
  end

  def shoe_wear_category(shoe)
    # for getting the right color for shoe card
    return "" if shoe.new_record?
    mileage_used = shoe.percent_retire_mileage
    if shoe.mileage < 1
      "eggplant"
    elsif mileage_used < 50
      "mint"
    elsif mileage_used < 90
      "mustard"
    else
      "poppy"
    end
  end

  # for the stimulus sort controller
  # want shoes to be sorted first by last_run_in date asc with nulls first
  # among the nulls, want to be sorted by created_at desc
  # note: won't correctly account for days with two runs since date only and not time
  # but that is not so important
  def sort_code(shoe)
    if shoe.last_run_in
      -(shoe.last_run_in.to_time.to_i)
    else
      shoe.created_at.to_time.to_i
    end
  end
end
