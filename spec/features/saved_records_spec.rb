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

    scenario 'save/unsave article' do
      @texts
      sign_in_user
      expect(page).to have_link(class: 'save-btn')
      expect{ within(class: 'text-area') do
                click_link(class: 'save-btn')
              end
            }.to change(SavedRecord, :count).by(1)
      expect(page).to have_content("Remove")
      click_on("Profile")
      expect(page).to have_content(@texts.first.headline)
      expect(page).to have_content("Remove")
      expect{ click_link(class: 'save-btn') }.to change(SavedRecord, :count).by(-1)
      expect(page).not_to have_content(@texts.first.blurb)
      click_on("Home")
      expect(page).to have_content(@texts.first.headline)
      expect{ within(class: 'text-area') do
                find('.save-btn', text: 'Save')
              end
            }
    end

  end

  context 'Non User' do
    scenario 'has no option to save an article' do
      expect(page).to have_content(@texts.first.headline)
      expect(page).to have_content(@spotlight.first.company_name)
      expect(page).not_to have_link(class: 'save-btn')
      expect(page).not_to have_content('Save')
      first(class: 'texts-link').click
      expect(page).to have_content("TEXT INDEX")
      expect(page).to have_content(@texts.first.headline)
      expect(page).not_to have_content("Save")
      expect(page).not_to have_link('save-btn')
      click_on(class: 'spotlights-link')
      expect(page).to have_content("SPOTLIGHT INDEX")
      expect(page).to have_content(@spotlight.first.company_name)
      expect(page).not_to have_content("Save")
      expect(page).not_to have_link(class: 'save-btn')
    end
  end

end
