# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Shoe.destroy_all
User.destroy_all

alice = User.create(email: "alice@fake.com", password: "123456")

shoes = [
  { brand: "Saucony", model: "Ride 16", mileage: 120.0, last_run_in: 1.week.ago, color: "blue" }, 
  { brand: "Brooks", model: "Hyperion Tempo", mileage: 50.0, last_run_in: 2.days.ago, color: "black/pink", category: 1 },
  { brand: "Hoka", model: "Clifton 9", mileage: 250.0, last_run_in: 1.day.ago, color: "blue/orange" }
]

shoes.each do |s|
  shoe = Shoe.new(s)
  shoe.user = alice
  shoe.save
end