require 'rails_helper'

feature 'Text Articles' do

  let(:admin){ create(:user, admin: true) }
  let(:user){ create(:user) }
  let(:text){ create(:text) }
  let(:sign_in_admin){ click_button "Sign In"
                       fill_in "Email", with: "#{admin.email}"
                       fill_in "password", with: "password"
                       fill_in "Confirm Password", with: "password"
                       click_button "Sign In"}
  let(:sign_in_user){ click_button "Sign In"
                      fill_in "Email", with: "#{user.email}"
                      fill_in "password", with: "password"
                      fill_in "Confirm Password", with: "password"
                      click_button "Sign In" }

  before do
    visit root_path
  end

  scenario 'add new text article' do
    headline = Faker::RickAndMorty.quote
    blurb = Faker::RickAndMorty.quote
    sign_in_admin
    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
    expect(page).to have_content("Add New")
    click_on(class: 'add-new-text-btn')
    expect(page).to have_content("Add New Text Article")
    fill_in "Headline", with: headline
    fill_in "Blurb", with: blurb
    fill_in class:"url", with: "https://www.adultswim.com/videos/rick-and-morty"
    click_button class: 'create-text-btn'
    expect(page).to have_content "Text Article Added Successfully!"
    expect(page).to have_content headline
    expect(page).to have_content blurb
  end

  scenario 'unable to add new text article' do
    headline = ""
    blurb = Faker::RickAndMorty.quote
    sign_in_admin
    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
    click_on(class: 'add-new-text-btn')
    expect(page).to have_content("Add New Text Article")
    fill_in "Headline", with: headline
    fill_in "Blurb", with: blurb
    fill_in class: 'url', with: ''
    click_button class: 'create-text-btn'
    expect(page).to have_content "error! Unable to Add Text Article - See Form For Errors"
    expect(page).to have_content "Headline can't be blank"
    expect(page).to have_content "Url can't be blank"
  end

  scenario 'update text article' do
    text
    new_headline = Faker::Simpsons.quote
    sign_in_admin
    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
    expect(page).to have_content("Edit")
    click_on class: 'edit-btn'
    expect(page).to have_content("Edit Text Article")
    fill_in "Headline", with: new_headline
    click_on "Update Text"
    expect(page).to have_content("TEXT INDEX")
    expect(page).to have_content new_headline
  end

  scenario 'unable to update text article' do
    text
    new_headline = ""
    sign_in_admin
    expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
    expect(page).to have_content("Edit")
    click_on class: 'edit-btn'
    expect(page).to have_content("Edit Text Article")
    fill_in "Headline", with: new_headline
    click_on "Update Text"
    expect(page).to have_content("error! Unable to Update Text Article - See Form For Errors")
    expect(page).to have_content("Headline can't be blank")
    expect(page).to have_content("Edit Text Article")
  end

  scenario 'delete a text article' do
    text
    sign_in_admin
    expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
    expect(page).to have_content("Delete")
    expect(page).to have_content("#{text.headline}")
    click_link "Delete"
    expect(page).to have_content("TEXT INDEX")
    expect(page).not_to have_content("#{text.headline}")
  end

  scenario 'unable to delete text article'

end
