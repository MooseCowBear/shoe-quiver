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

# 8 shoes, upto 15 runs per shoe... <= 120 dates needed
recentish_dates = (0..120).to_a 

# curr rotation
shoes.each do |s|
  shoe = Shoe.new(s)
  shoe.user = alice
  shoe.save

  #add runs
  num_runs = rand(0..15)
  run_dates = recentish_dates.sample(num_runs)
  recentish_dates.reject! {|elem| run_dates.include?(elem) } #so will get one run per date

  run_dates.each do |d|
    dist = rand(2..26)
    min_dur = dist*6*60
    max_dur = dist*10*60
    dur = rand(min_dur..max_dur)
    Run.create(shoe: shoe, user: alice, distance: dist, duration: dur, date: Date.today - d, felt: rand(0..3))
  end
end

# 24, upto 40 runs per shoe <= 960
max = 960 - recentish_dates.length + 120
older_dates = (121..max).to_a

# retired shoes, want enough to test pagination
3.times do
  shoes.each do |s|
    num_runs = rand(25..40)
    run_dates = []
    if recentish_dates.length >= num_runs
      run_dates = recentish_dates.sample(num_runs)
    else
      run_dates = run_dates + recentish_dates
      difference = num_runs - run_dates.length
      other_dates = older_dates.sample(difference)
      run_dates = run_dates + other_dates
    end

    recentish_dates.reject! {|elem| run_dates.include?(elem) }
    older_dates.reject! {|elem| run_dates.include?(elem) }
    run_dates.sort!

    shoe = Shoe.new(s)
    shoe.user = alice
    shoe.retired_on = Date.today - run_dates.last
    shoe.save

    run_dates.each do |d|
      dist = rand(2..26)
      min_dur = dist*6*60
      max_dur = dist*10*60
      dur = rand(min_dur..max_dur)
      Run.create(shoe: shoe, user: alice, distance: dist, duration: dur, date: Date.today - d, felt: rand(0..3))
    end
  end
end

