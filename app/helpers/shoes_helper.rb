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
    if mileage_used < 1
      "eggplant"
    elsif mileage_used < 50
      "mint"
    elsif mileage_used < 90
      "mustard"
    else
      "poppy"
    end
  end
end
