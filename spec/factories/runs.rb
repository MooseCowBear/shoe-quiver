FactoryBot.define do
  factory :run do
    user { nil }
    shoe { nil }
    distance { "9.99" }
    duration { 1 }
    felt { 1 }
    notes { "MyText" }
    date { 1.day.ago }
  end
end
