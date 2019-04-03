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
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
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
    fill_in "user_password", with: "pass"
    fill_in "Password confirmation", with: "word"
    expect{ click_button "Create User"}.to change(User, :count).by(0)
    expect(page).to have_content "Unable to Sign up - see form for errors"
    expect(page).to have_content "First name is too short (minimum is 2 characters)"
    expect(page).to have_content "Last name is too short (minimum is 2 characters)"
    expect(page).to have_content "Email Must contain @ and ."
    expect(page).to have_content "Password is too short (minimum is 7 characters)"
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'log in as returning user' do
    click_button "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content "Welcome Back!"
    expect(page).to have_content "Welcome to GNN, where all the news is good news!"
    expect(page).to have_content "Sign Out"
  end

  scenario 'unable to log in due to wrong info' do
    click_button "Sign In"
    fill_in "Email", with: "blkajbdlkj"
    fill_in "password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content "Unable to sign in - Please check username and password"
    expect(page).to have_content "Welcome to GNN, where all the news is good news!"
    expect(page).to have_content "Sign Up"
    expect(page).to have_content "Sign In"
  end

  scenario 'logout' do
    click_button "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content "Sign Out"
    click_on(class: 'logout-link')
    expect(page).to have_content "You've successfully logged out"
    expect(page).to have_content "Welcome to GNN, where all the news is good news!"
    expect(page).to have_content "Sign Up"
    expect(page).to have_content "Sign In"
  end

  scenario 'edit profile info successfully' do
    click_button "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    click_link "Profile"
    click_link "Edit Personal Information"
    expect(page).to have_content "Edit your Information"
    fill_in "First name", with: "Baby"
    fill_in "Last name", with: "Face"
    click_button "Update User"
    expect(page).to have_content "success! User info updated successfully"
    expect(page).to have_content "Welcome, Baby Face!"
    expect(page).to have_content "Check out your recently saved articles:"
  end

  scenario 'edit profile info unsuccessfully' do
    click_button "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    click_link "Profile"
    click_link "Edit Personal Information"
    expect(page).to have_content "Edit your Information"
    fill_in "First name", with: "A"
    fill_in "Last name", with: "B"
    fill_in "Password", with: "pass"
    fill_in "Password confirmation", with: "word"
    click_button "Update User"
    expect(page).to have_content "error! Unable to update user info - see form for errors"
    expect(page).to have_content "Edit your Information"
    expect(page).to have_content "First name is too short (minimum is 2 characters)"
    expect(page).to have_content "Last name is too short (minimum is 2 characters)"
    expect(page).to have_content "Password is too short (minimum is 7 characters)"
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'check out about page and contact page' do
    click_button "Sign In"
    fill_in "Email", with: "#{user.email}"
    fill_in "password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Sign In"
    expect(page).to have_content "#{user.first_name} #{user.last_name}"
    click_link "About"
    expect(page).to have_content "About GNN"
    click_link "Home"
    click_link "Contact"
    expect(page).to have_content "Contact Us!"
  end


end
