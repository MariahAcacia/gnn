require 'rails_helper'

feature 'Giving Companies' do

  let(:admin){ create(:user, admin: true) }
  let(:user){ create(:user) }
  let(:company){ create(:giving) }
  let(:sign_in_admin){ click_button "Sign In"
                       fill_in "Email", with: "#{admin.email}"
                       fill_in "password", with: "password"
                       fill_in "Confirm Password", with: "password"
                       click_button "Sign In"
                       expect(page).to have_content("Welcome Back!")
                       expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
                       expect(page).to have_content("Welcome to GNN, where all the news is good news!")}
  let(:sign_in_user){ click_button "Sign In"
                      fill_in "Email", with: "#{user.email}"
                      fill_in "password", with: "password"
                      fill_in "Confirm Password", with: "password"
                      click_button "Sign In"
                      expect(page).to have_content("Welcome Back!")
                      expect(page).to have_content("#{user.first_name} #{user.last_name}")
                      expect(page).to have_content("Welcome to GNN, where all the news is good news!")}

  let(:company_name){"New Company"}
  let(:url){"www.companyname.com"}
  let(:blurb){"Blah blah blah"}
  let(:twitter){"www.twitter.com/companyname"}

  before do
    visit root_path
  end

  context 'Admin' do
    before :each do
      company
      sign_in_admin
    end
    scenario 'add New company' do
      expect(page).to have_link(class: 'add-new-giving-btn')
      click_link(class: 'add-new-giving-btn')
      expect(page).to have_content("HOME")
      expect(page).to have_content("Add New Giving Company")
      fill_in "Company name", with: company_name
      fill_in "Url", with: url
      fill_in "Blurb", with: blurb
      fill_in "Twitter", with: twitter
      expect{ click_on(class: 'create-giving-btn') }.to change(Giving, :count).by(1)
      expect(page).to have_content("success! New Giving Option Added")
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content(company_name)
      expect(page).to have_content(blurb)
      click_on("HOME")
      expect(page).to have_content(company_name)
      expect(page).to have_content(blurb)
    end

    scenario 'unable to add new company' do
      expect(page).to have_link(class: 'add-new-giving-btn')
      click_link(class: 'add-new-giving-btn')
      expect(page).to have_content("HOME")
      expect(page).to have_content("Add New Giving Company")
      fill_in "Twitter", with: twitter
      expect{ click_on(class: 'create-giving-btn') }.to change(Giving, :count).by(0)
      expect(page).to have_content("Add New Giving Company")
      expect(page).to have_content("error! Unable to Add New Giving Option - See Form For Errors")
      expect(page).to have_content("Blurb can't be blank and Blurb is too short (minimum is 10 characters)")
      expect(page).to have_content("Url can't be blank")
    end

    scenario 'edit company' do
      expect(page).to have_content(company.company_name)
      expect(page).to have_link(class: 'edit-btn')
      click_link(class: 'edit-btn')
      expect(page).to have_content("HOME")
      expect(page).to have_content("Edit Giving Company")
      fill_in "Company name", with: company_name
      click_on "Update Giving"
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content(company_name)
      click_on("HOME")
      expect(page).to have_content("Welcome to GNN,")
      expect(page).to have_content(company_name)
    end

    scenario 'unable to edit company' do
      expect(page).to have_content(company.company_name)
      expect(page).to have_link(class: 'edit-btn')
      click_link(class: 'edit-btn')
      expect(page).to have_content("Edit Giving Company")
      fill_in "Company name", with: ""
      fill_in "Name", with: ""
      click_on "Update Giving"
      expect(page).to have_content("error! Unable to Update Giving Option - See Form For Errors")
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Company name can't be blank")
    end

    scenario 'delete company' do
      expect(page).to have_link(class: 'delete-btn')
      expect(page).to have_content(company.company_name)
      expect{ click_link(class: 'delete-btn') }.to change(Giving, :count).by(-1)
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content("success! Giving Option DELETE Successfully (this action cannot be undone)")
      expect(page).not_to have_content(company.company_name)
    end

  end

  context 'User' do

    before :each do
      company
      sign_in_user
    end

    scenario 'no option to add new' do
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'add-new-giving-btn')
      expect(page).to have_link(class: 'gygos-link')
      click_link(class: 'gygos-link')
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'add-new-giving-btn')
    end

    scenario 'no option to edit' do
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'edit-btn')
      expect(page).to have_link(class: 'gygos-link')
      click_link(class: 'gygos-link')
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'edit-btn')
    end

    scenario 'no option to delete' do
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'delete-btn')
      expect(page).to have_link(class: 'gygos-link')
      click_link(class: 'gygos-link')
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'delete-btn')
    end

    scenario 'save and remove article' do
      expect(page).to have_content(company.company_name)
      expect(page).to have_link(class: 'save-btn')
      click_link(class: 'gygos-link')
      expect(page).to have_content(company.company_name)
      expect(page).to have_link(class: 'save-btn')
      expect(page).to have_content("Save")
      click_link(class: 'save-btn')
      expect(page).to have_content(company.company_name)
      expect(page).to have_content("Remove")
      click_link(class: 'saved-giving-index')
      expect(page).to have_content("Your Saved Giving Links")
      expect(page).to have_content(company.company_name)
      expect(page).to have_content("Remove")
      expect(page).to have_link(class: 'save-btn')
      click_link(class: 'save-btn')
      expect(page).to have_content("Your Saved Giving Links")
      expect(page).not_to have_content(company.company_name)
      click_on("Home")
      expect(page).to have_content("Welcome")
      expect(page).to have_content(company.company_name)
      expect(page).to have_link(class: 'save-btn')
      expect(page).to have_content("Save")
    end

  end

  context 'Non User' do
    before :each do
      company
      visit root_path
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(company.company_name)
    end
    scenario 'no option to add new' do
      expect(page).not_to have_link(class: 'add-new-giving-btn')
      click_link(class: 'gygos-link')
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'add-new-giving-btn')
    end
    scenario 'no option to edit' do
      expect(page).not_to have_link(class: 'edit-btn')
      click_link(class: 'gygos-link')
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'edit-btn')
    end
    scenario 'no option to save' do
      expect(page).not_to have_link(class: 'save-btn')
      click_link(class: 'gygos-link')
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'save-btn')
    end
    scenario 'no option to delete' do
      expect(page).not_to have_link(class: 'delete-btn')
      click_link(class: 'gygos-link')
      expect(page).to have_content("GIVING INDEX")
      expect(page).to have_content(company.company_name)
      expect(page).not_to have_link(class: 'delete-btn')
    end
    scenario 'searching for companies' do
      click_link(class: 'gygos-link')
      expect(page).to have_button("Search")
      fill_in "Search Companies", with: company.company_name
      click_on("Search")
      expect(page).to have_content(company.company_name)
      expect(page).to have_content("Search Index")
      expect(page).to have_content(company.company_name)
    end
  end

end
