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

  def shoe_card_classes(shoe)
    # for getting the right color for shoe card
    return "" if shoe.new_record?
    mileage_used = shoe.percent_retire_mileage
    if shoe.mileage < 1
      "bg-eggplant text-neutral-50 darK:bg-eggplant/90"
    elsif mileage_used < 50
      "bg-mint text-neutral-50 dark:bg-mint/90"
    elsif mileage_used < 90
      "bg-mustard text-eggplant dark:bg-mustard/90 dark:text-neutral-900"
    else
      "bg-poppy text-neutral-50 dark:bg-poppy/90"
    end
  end

  def border_classes(shoe)
    return "border-mint" if shoe.new_record?
    mileage_used = shoe.percent_retire_mileage
    if shoe.mileage < 1
      "border-neutral-50"
    elsif mileage_used < 50
      "border-neutral-50"
    elsif mileage_used < 90
      "border-eggplant dark:border-neutral-900"
    else
      "border-neutral-50"
    end
  end

  def svg_classes(shoe)
    return "" if shoe.new_record?
    mileage_used = shoe.percent_retire_mileage
    if shoe.mileage < 1
      "fill-neutral-50"
    elsif mileage_used < 50
      "fill-neutral-50"
    elsif mileage_used < 90
      "fill-eggplant dark:fill-neutral-900"
    else
      "fill-neutral-50"
    end
  end

  def hover_classes(shoe)
    return "hover:border-mint" if shoe.new_record?
    mileage_used = shoe.percent_retire_mileage
    if shoe.mileage < 1
      "hover:border-neutral-50"
    elsif mileage_used < 50
      "hover:border-neutral-50"
    elsif mileage_used < 90
      "hover:border-eggplant hover:dark:border-neutral-900"
    else
      "hover:border-neutral-50"
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
