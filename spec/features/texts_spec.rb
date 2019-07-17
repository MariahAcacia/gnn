require 'rails_helper'

feature 'Text Articles' do

  let(:admin){ create(:user, admin: true) }
  let(:user){ create(:user) }
  let(:text){ create(:text) }
  let(:sign_in_admin){ click_link "Login"
                       fill_in "Email", with: "#{admin.email}"
                       fill_in "password", with: "password"
                       fill_in "Confirm Password", with: "password"
                       click_on(class: "login-btn")
                       expect(page).to have_content("Welcome Back!")
                       expect(page).to have_content("#{admin.first_name} #{admin.last_name}")}
  let(:sign_in_user){ click_link "Login"
                      fill_in "Email", with: "#{user.email}"
                      fill_in "password", with: "password"
                      fill_in "Confirm Password", with: "password"
                      click_on(class: 'login-btn') }

  before  do
    visit root_path
  end

  context 'Admin' do

    before :each do
      sign_in_admin
      @texts = [create(:text)]
      visit root_path
    end

    scenario 'add new' do
      headline = Faker::TvShows::RickAndMorty.quote
      blurb = Faker::TvShows::RickAndMorty.quote
      expect(page).to have_link(class: 'add-new-text-btn')
      click_on(class: 'add-new-text-btn')
      expect(page).to have_content("Add New Text Article")
      fill_in "Headline", with: headline[0,30]
      fill_in "Blurb", with: blurb[0,200]
      fill_in class:"url", with: "https://www.adultswim.com/videos/rick-and-morty"
      click_button class: 'create-text-btn'
      expect(page).to have_content("Text Article Added Successfully!")
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content(headline[0,30].strip)
      expect(page).to have_content(blurb[0,200])
    end

    scenario 'unable to add new' do
      headline = ""
      blurb = Faker::TvShows::RickAndMorty.quote
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

    scenario 'update' do
      visit root_path
      new_headline = Faker::TvShows::Simpsons.quote[0,30]
      expect(page).to have_link(class: 'edit-btn')
      click_on class: 'edit-btn'
      expect(page).to have_content("Edit Text Article")
      fill_in "Headline", with: new_headline
      click_on "Update Text"
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content new_headline
    end

    scenario 'unable to update' do
      new_headline = ""
      expect(page).to have_link(class: 'edit-btn')
      first(:link, class: 'edit-btn').click
      expect(page).to have_content("Edit Text Article")
      fill_in "Headline", with: new_headline
      click_on "Update Text"
      expect(page).to have_content("error! Unable to Update Text Article - See Form For Errors")
      expect(page).to have_content("Headline can't be blank")
      expect(page).to have_content("Edit Text Article")
    end

    scenario 'delete' do
      expect(page).to have_link(class: 'delete-btn')
      first(class: 'texts-link').click
      expect(page).to have_content("#{@texts.first.headline}")
      first(:link, class: 'delete-btn').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).not_to have_content("#{@texts.first.headline}")
    end

  end

  context 'User' do
    before :each do
      text
      sign_in_user
    end

    scenario 'save and remove a text article' do
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(text.headline)
      expect(page).to have_link(class: 'save-btn')
      click_link(class: 'save-btn')
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(text.headline)
      expect(page).to have_link(class: 'save-btn')
      click_link(class: 'saved-text-index')
      expect(page).to have_content("Your Saved Text Links")
      expect(page).to have_content(text.headline)
      expect(page).to have_link(class: 'save-btn')
      expect(page).to have_content("Remove")
      click_link(class: 'save-btn')
      expect(page).to have_content("Your Saved Text Links")
      expect(page).not_to have_content(text.headline)
      expect(page).not_to have_link(class: 'save-btn')
      click_on("Home")
      expect(page).to have_content(text.headline)
      expect(page).to have_content("Save")
      expect(page).to have_link(class: 'save-btn')
      expect(page).to have_content("Save")
    end
  end

  context 'Any User' do

    scenario 'search' do
      text = create(:text)
      visit root_path
      expect(page).to have_content(text.headline.strip)
      first(class: 'texts-link').click
      expect(page).to have_content("TEXT INDEX")
      fill_in "text_query", with: text.headline[0,5]
      click_on "Search"
      expect(page).to have_content("Text Search Index")
      expect(page).to have_content(text.headline.strip)
    end

    before :each do
      text
      visit root_path
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(text.headline)
    end

    scenario 'no option to save' do
      expect(page).not_to have_link(class: 'save-btn')
      first(class: 'texts-link').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content(text.headline)
      expect(page).not_to have_link(class: 'save-btn')
    end

    scenario 'no option to delete' do
      expect(page).not_to have_link(class: 'delete-btn')
      first(class: 'texts-link').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content(text.headline)
      expect(page).not_to have_link(class: 'delete-btn')
    end

    scenario 'no option to create new' do
      expect(page).not_to have_link(class: 'add-new-text-btn')
      first(class: 'texts-link').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content(text.headline)
      expect(page).not_to have_link(class: 'add-new-text-btn')
    end

    scenario 'no option to edit' do
      expect(page).not_to have_link(class: 'edit-btn')
      first(class: 'texts-link').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content(text.headline)
      expect(page).not_to have_link(class: 'edit-btn')
    end
  end

end
