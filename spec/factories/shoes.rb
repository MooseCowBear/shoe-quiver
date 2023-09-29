FactoryBot.define do
  factory :shoe do
    brand { "saucony" }
    model { "ride 16" }
    mileage { 50 }
    category { 0 }
    retired_on { nil }
    last_run_in { nil }
    retire_at { 500 }

    trait :retired do
      retired_on { 1.week.ago }
    end

    trait :speed_shoe do
      category { 1 }
    end

    trait :race_shoe do
      category { 2 }
    end
  end
end