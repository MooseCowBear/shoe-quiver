# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

alice = User.create(email: "alice@fake.com", password: "123456")

shoes = [
  { brand: "Saucony", model: "Ride 16", color: "blue" }, 
  { brand: "Brooks", model: "Hyperion Tempo", color: "black/pink", category: 1 },
  { brand: "Hoka", model: "Clifton 9", color: "blue/orange" },
  { brand: "Saucony", model: "Triumph 21", color: "lavender" },
  { brand: "Hoka", model: "Mach 5", color: "blue/yellow", category: 1 },
  { brand: "Saucony", model: "Ride 16", color: "green" },
  { brand: "Brooks", model: "Cascadia 17", color: "white/black" },
  { brand: "Asics", model: "MetaSpeed Sky+", color: "neon yellow", category: 2 }
]

# curr rotation
shoes.each do |s|
  shoe = Shoe.new(s)
  shoe.user = alice
  shoe.save

  #add runs
  num_runs = rand(0..10)
  num_runs.times do
    dist = rand(2..26)
    min_dur = dist*6*60
    max_dur = dist*10*60
    dur = rand(min_dur..max_dur)
    Run.create(shoe: shoe, user: alice, distance: dist, duration: dur, date: Date.today - rand(20), felt: rand(0..3))
  end
end

# retired shoes, want enough to test pagination
3.times do
  shoes.each do |s|
    shoe = Shoe.new(s)
    shoe.user = alice
    last_day = Date.today - rand(200)
    shoe.retired_on = last_day
    shoe.save

    num_runs = rand(30..50)
    num_runs.times do
      dist = rand(2..26)
      min_dur = dist*6*60
      max_dur = dist*10*60
      dur = rand(min_dur..max_dur)
      Run.create(shoe: shoe, user: alice, distance: dist, duration: dur, date: last_day - rand(num_runs), felt: rand(0..3))
    end
  end
end

