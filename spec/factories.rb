require 'faker'

FactoryBot.define do

  factory :user do
    first_name { "#{Faker::Name.first_name}" }
    last_name { "#{Faker::Name.last_name}" }
    email { "#{first_name}.#{last_name}@yada.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :text do
    headline { "#{Faker::TvShows::RickAndMorty.quote}".first(30).strip }
    blurb { "#{Faker::TvShows::RickAndMorty.quote}".first(200).strip }
    url { "https://www.adultswim.com/videos/rick-and-morty" }
  end

  factory :video do
    headline { "#{Faker::TvShows::Simpsons.quote}".first(30).strip }
    blurb { "#{Faker::TvShows::Simpsons.quote}".first(200) }
    url { "http://www.simpsonsworld.com/" }
  end

  factory :spotlight do
    company_name { Faker::Space.nebula }
    name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    url { "#{Faker::Internet.url}" }
    blurb { "#{Faker::TvShows::RickAndMorty.quote}" }
    twitter { "www.twitter.com" }
    instagram { "www.instagram" }
    facebook { "www.facebook.com" }
    email { "#{name}@faker.com" }
  end

  factory :giving do
    company_name { Faker::Movies::HitchhikersGuideToTheGalaxy.planet }
    name { Faker::Movies::PrincessBride.character }
    url { Faker::Internet.url }
    blurb { Faker::Movies::PrincessBride.quote.first(350) }
    twitter { "www.twitter.com/#{name}" }
    instagram { "www.instagram/#{name}" }
    facebook { "www.facebook.com/#{name}" }
    email { "#{name}@faker.com" }
  end

  factory :saved_record do
    user
    saveable{ create(:text) }
  end

end
