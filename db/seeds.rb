# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Text.destroy_all
  puts "destroyed all text articles"
end

MULTIPLIER  = 10

MULTIPLIER.times do |x|
  headline = Faker::RickAndMorty.quote
  blurb = Faker::RickAndMorty.quote
  url = "https://www.adultswim.com/videos/rick-and-morty"
  if Text.create(headline: headline, blurb: blurb, url: url)
    puts "Text Created"
  end
end
