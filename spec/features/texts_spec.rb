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
    sign_in_admin
    expect(page).to have_content("Welcome Back!")
    expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
    expect(page).to have_content("Add New")
    click_on(class: 'add-new-text-btn')
    expect(page).to have_content("Add New Text Article")
    fill_in "Headline", with: Faker::RickAndMorty.quote
    fill_in "Blurb", with: Faker::RickAndMorty.quote
    fill_in "url", with: "https://www.adultswim.com/videos/rick-and-morty"
  end
  scenario 'unable to add new text article'
  scenario 'update text artcile'
  scenario 'unable to update text article'
  scenario 'delete a text article'
  scenario 'unable to delete text article'

end
