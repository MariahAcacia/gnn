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

if User.destroy_all
  puts 'destroyed all users'
end

if Giving.destroy_all
  puts 'destroyed all Giving Companies'
end

MULTIPLIER  = 10

MULTIPLIER.times do |x|
  first_name = Faker:: Name.first_name
  last_name = Faker::Name.last_name
  password = 'password'
  if User.create(first_name: first_name,
                  last_name: last_name,
                      email:  "#{first_name}.#{last_name}@domain.com",
                   password: password,
      password_confirmation: password)
      puts "User Created Successfully!"
  end
end

MULTIPLIER.times do |x|
  headline = Faker::TvShows::MichaelScott.quote
  blurb = Faker::TvShows::MichaelScott.quote
  url = "https://www.imdb.com/title/tt0386676/"
  if Text.create(headline: headline, blurb: blurb, url: url)
    puts "Text Created"
  end
end


MULTIPLIER.times do |x|
  headline = Faker::TvShows::GameOfThrones.quote
  blurb = Faker::TvShows::GameOfThrones.quote
  url = "https://www.hbo.com/game-of-thrones"
  if Video.create(headline: headline, blurb: blurb, url: url)
    puts "Video Created"
  end
end

7.times do |x|
  company_name = Faker::TvShows::Seinfeld.business
  name = Faker::TvShows::Seinfeld.character
  blurb = Faker::TvShows::Seinfeld.quote
  url = "https://www.imdb.com/title/tt0098904/"
  twitter = "www.twitter.com/#{company_name}"
  if Spotlight.create(company_name: company_name, name: name, blurb: blurb, url: url, twitter: twitter)
    puts "Spotlight Created"
  end
end

3.times do |x|
  company_name = Faker::TvShows::Seinfeld.business
  name = Faker::TvShows::Seinfeld.character
  blurb = Faker::TvShows::Seinfeld.quote
  description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  url = "https://www.imdb.com/title/tt0098904/"
  twitter = "www.twitter.com/#{company_name}"
  if Spotlight.create(company_name: company_name, name: name, blurb: blurb, url: url, twitter: twitter, description: description)
    puts "Spotlight Created with description"
  end
end

if User.create( email: 'mariah.acacia@gmail.com',
                first_name: 'Mar',
                last_name: 'Schnee',
                admin: true,
                password: '8Admin74B',
                password_confirmation: '8Admin74B')
    puts 'Admin Created'
  end

6.times do |x|
  company_name = Faker::TvShows::Friends.location
  name = Faker::TvShows::Friends.character
  blurb = Faker::TvShows::Friends.quote
  url = "https://www.imdb.com/title/tt0108778/"
  instagram = "www.instagram.com/#{company_name}"
  if Giving.create(company_name: company_name, name: name, blurb: blurb, url: url, instagram: instagram)
    puts "Giving Created"
  end
end

4.times do |x|
  company_name = Faker::TvShows::Friends.location
  name = Faker::TvShows::Friends.character
  blurb = Faker::TvShows::Friends.quote
  url = "https://www.imdb.com/title/tt0108778/"
  description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  instagram = "www.instagram.com/#{company_name}"
  if Giving.create(company_name: company_name, name: name, blurb: blurb, url: url, instagram: instagram, description: description)
    puts "Giving Created w/ description"
  end
end
