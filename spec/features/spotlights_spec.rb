require 'rails_helper'

feature 'Spotlight Articles' do

    let(:admin){ create(:user, admin: true) }
    let(:user){ create(:user) }
    let(:spotlight){ create(:spotlight) }
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

    let(:company_name){"New Company"}
    let(:url){"www.companyname.com"}
    let(:blurb){"Blah blah blah"}
    let(:twitter){"www.twitter.com/companyname"}

    before do
      visit root_path
    end

    scenario 'Admin add new Spotlight Article' do
      sign_in_admin
      expect(page).to have_content("Welcome Back!")
      expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
      expect(page).to have_link(class: 'add-new-spotlight-btn')
      click_on(class: 'add-new-spotlight-btn')
      expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
      expect(page).to have_content("HOME")
      expect(page).to have_content("Add New Spotlight")
      fill_in "Company name", with: company_name
      fill_in "Url", with: url
      fill_in "Blurb", with: blurb
      fill_in "Twitter", with: twitter
      expect{click_on "Create Spotlight"}.to change(Spotlight, :count).by(1)
      expect(page).to have_content("success! New Spotlight Added Successfully!")
      expect(page).to have_content("SPOTLIGHT INDEX")
      expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
      expect(page).to have_content("HOME")
      expect(page).to have_content("SPOTLIGHT INDEX")
      expect(page).to have_content(company_name)
      expect(page).to have_content(blurb)
    end

    scenario 'Admin unable to add new spotlight with invalid inputs' do
      sign_in_admin
      expect(page).to have_content("Welcome Back!")
      expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
      expect(page).to have_link(class: 'add-new-spotlight-btn')
      click_on(class: 'add-new-spotlight-btn')
      expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
      expect(page).to have_content("HOME")
      expect(page).to have_content("Add New Spotlight")
      fill_in "Url", with: url
      fill_in "Blurb", with: blurb
      fill_in "Twitter", with: twitter
      expect{click_on "Create Spotlight"}.to change(Spotlight, :count).by(0)
      expect(page).to have_content("error! Unable to Add New Spotlight - See Form For Errors")
      expect(page).to have_content("Add New Spotlight")
      expect(page).to have_content("Company name can't be blank")
      expect(page).to have_content("Name can't be blank")
    end

    scenario 'Admin update spotlight article' do
      spotlight
      sign_in_admin
      expect(page).to have_content("Welcome Back!")
      expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
      expect(page).to have_content(spotlight.company_name)
      expect(page).to have_link(class: 'edit-btn')
      click_on(class: 'edit-btn')
      expect(page).to have_content("Edit Spotlight")
    end
    scenario 'Admin unable to update spotlight article'
    scenario 'Admin delete article'
    scenario 'User should not have option to add new spotlight'
    scenario 'User should not have option to update spotlight'
    scenario 'User should not have option to delete spotlight'
    scenario 'Non-user should not have option to add new spotlight'
    scenario 'Non-user should not have option to update spotlight'
    scenario 'Non-user should not have option to delete spotlight'


end
