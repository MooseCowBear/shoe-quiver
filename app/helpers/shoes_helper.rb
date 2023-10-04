module ShoesHelper
  def category_identifier(shoe)
    # for making little css visuals for shoe type
    case shoe.category
    when :daily_trainer
      "dt"
    when :speed
      "s"
    when :race
      "r"
    end
  end
end
