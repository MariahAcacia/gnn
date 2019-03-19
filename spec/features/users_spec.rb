require 'rails_helper'

feature 'User Accounts' do
  before do
    visit root_path
  end

  scenario 'add new user' do
    click_link 'Sign Up'
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    fill_in "First name", with: "#{first_name}"
    fill_in "Last name", with: "#{last_name}"
    fill_in "Email", with: "#{first_name}.#{last_name}@mail.net"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    expect{ click_button "Create User" }.to change(User, :count).by(1)
    expect(page).to have_content "Welcome, #{first_name} #{last_name}!"
    expect(page).to have_content "success! you are now signed up!"

  end
end
