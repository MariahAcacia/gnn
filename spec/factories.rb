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
    headline { "#{Faker::RickAndMorty.quote}" }
    blurb { "#{Faker::RickAndMorty.quote}" }
    url { "https://www.adultswim.com/videos/rick-and-morty" }
  end


end
