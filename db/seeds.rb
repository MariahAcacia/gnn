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

if Video.destroy_all
  puts "destroyed all video articles"
end

if Spotlight.destroy_all
  puts "destroyed all spotlight articles"
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


MULTIPLIER.times do |x|
  headline = Faker::Simpsons.quote
  blurb = Faker::Simpsons.quote
  url = "www.simpsonsworld.com"
  if Video.create(headline: headline, blurb: blurb, url: url)
    puts "Video Created"
  end
end

MULTIPLIER.times do |x|
  company_name = Faker::Company.name
  name = Faker::RickAndMorty.character
  blurb = Faker::RickAndMorty.quote
  url = "https://www.adultswim.com/videos/rick-and-morty"
  twitter = "www.twitter.com/#{company_name}"
  if Spotlight.create(company_name: company_name, name: name, blurb: blurb, url: url, twitter: twitter)
    puts "Spotlight Created"
  end 
end
