require 'rails_helper'

feature 'Text Articles' do

  let(:admin){ create(:user, admin: true) }
  let(:user){ create(:user) }
  let(:text){ create(:text) }
  let(:sign_in_admin){ click_button "Sign In"
                       fill_in "Email", with: "#{admin.email}"
                       fill_in "password", with: "password"
                       fill_in "Confirm Password", with: "password"
                       click_button "Sign In"
                       expect(page).to have_content("Welcome Back!")
                       expect(page).to have_content("#{admin.first_name} #{admin.last_name}")}
  let(:sign_in_user){ click_button "Sign In"
                      fill_in "Email", with: "#{user.email}"
                      fill_in "password", with: "password"
                      fill_in "Confirm Password", with: "password"
                      click_button "Sign In" }

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
      new_headline = Faker::TvShows::Simpsons.quote
      expect(page).to have_link(class: 'edit-btn')
      click_on class: 'edit-btn'
      expect(page).to have_content("Edit Text Article")
      fill_in "Headline", with: new_headline[0,30]
      click_on "Update Text"
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content new_headline[0,30]
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
      click_link(class: 'texts-link')
      expect(page).to have_content("#{@texts.first.headline}")
      first(:link, class: 'delete-btn').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).not_to have_content("#{@texts.first.headline}")
    end

    scenario 'unable to delete'
  end

  context 'Any User' do
    scenario 'search' do
      text = create(:text)
      visit root_path
      expect(page).to have_content(text.headline.strip)
      click_link(class: 'texts-link')
      expect(page).to have_content("TEXT INDEX")
      fill_in "text_query", with: text.headline[0,5]
      click_on "Search"
      expect(page).to have_content("Text Search Index")
      expect(page).to have_content(text.headline.strip)
    end
  end

end
