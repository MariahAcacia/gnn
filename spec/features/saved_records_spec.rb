require 'rails_helper'

feature 'Saved Records' do


  before do
    @texts = [create(:text)]
    @spotlight = [create(:spotlight)]
    visit root_path
  end

  context 'Admin' do

    let(:admin){ create(:user, admin: true) }
    let(:sign_in_admin){ click_button "Sign In"
                         fill_in "Email", with: "#{admin.email}"
                         fill_in "password", with: "password"
                         fill_in "Confirm Password", with: "password"
                         click_button "Sign In"
                         expect(page).to have_content("Welcome Back!")
                         expect(page).to have_content("#{admin.first_name} #{admin.last_name}")}

    scenario 'save an article for later' do

    end

    scenario 'unsave an article' do
    end

  end

  context 'User' do
    let(:user){ create(:user) }
    let(:video){ create(:video) }
    let(:spotlight){ create(:spotlight) }
    let(:sign_in_user){ click_button "Sign In"
                        fill_in "Email", with: "#{user.email}"
                        fill_in "password", with: "password"
                        fill_in "Confirm Password", with: "password"
                        click_button "Sign In"
                        expect(page).to have_content("Welcome Back!")
                        expect(page).to have_content("#{user.first_name} #{user.last_name}")}

    scenario 'save an article for later' do
      text
      sign_in_user
      expect(page).to have_link(class: 'save-btn')
      expect{ within(class: 'text-area') do
                click_link(class: 'save-btn')
              end
            }.to change(SavedRecord, :count).by(1)
      expect(page).to have_content("Remove")
      click_on("Profile")
      expect(page).to have_content(text)
      expect(page).to have_content("Remove")
    end
    scenario 'unsave an article' do
    end
  end

  context 'Non User' do
    scenario 'has no option to save an article'
    scenario 'has no option to unsave article'
  end

end
