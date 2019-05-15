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
    headline { "#{Faker::TvShows::RickAndMorty.quote}".first(30) }
    blurb { "#{Faker::TvShows::RickAndMorty.quote}".first(200) }
    url { "https://www.adultswim.com/videos/rick-and-morty" }
  end

  factory :video do
    headline { "#{Faker::TvShows::Simpsons.quote}".first(200) }
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
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.character }
    url { Faker::Internet.url }
    blurb { Faker::Movies::HitchhikersGuideToTheGalaxy.quote.first(350) }
    twitter { "www.twitter.com/#{name}" }
    instagram { "www.instagram/#{name}" }
    facebook { "www.facebook.com/#{name}" }
    email { "#{name}@faker.com" }
  end

end
