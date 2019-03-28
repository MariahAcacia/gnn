require 'rails_helper'
require 'factory_bot'

feature 'User Accounts' do
  let(:user){ create(:user) }


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

  scenario 'unable to add new user' do
    click_link 'Sign Up'
    first_name = "B"
    last_name = "F"
    fill_in "First name", with: "#{first_name}"
    fill_in "Last name", with: "#{last_name}"
    fill_in "Email", with: "#{first_name}.#{last_name}"
    fill_in "Password", with: "pass"
    fill_in "Password confirmation", with: "word"
    expect{ click_button "Create User"}.to change(User, :count).by(0)
    expect(page).to have_content "Unable to Sign up - see form for errors"
    expect(page).to have_content "First Name is too short (minimum is 2 characters)"
    expect(page).to have_content "Last Name is too short (minimum is 2 characters)"
    expect(page).to have_content "Email Must contain @ and ."
    expect(page).to have_content "Password is too short (minimum is 7 characters)"
    expect(page).to have_content "Password Confirmation doesn't match Password"
  end

  scenario 'log in as returning user' do
    click_button "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content "Welcome Back!"
    expect(page).to have_content "Welcome to GNN where you can find good news"
    expect(page).to have_content "Sign Out"
  end

  scenario 'unable to log in due to wrong info' do
    click_button "Sign In"
    fill_in "Email", with: "blkajbdlkj"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content "Unable to sign in - Please check username and password"
    expect(page).to have_content "Welcome to GNN where you can find good news"
    expect(page).to have_content "Sign Up | Sign In"
  end


end
