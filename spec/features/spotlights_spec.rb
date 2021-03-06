require 'rails_helper'

feature 'Spotlight Articles' do

    let(:admin){ create(:user, admin: true) }
    let(:user){ create(:user) }
    let(:spotlight){ create(:spotlight) }
    let(:sign_in_admin){ click_link "Login"
                         fill_in "Email", with: "#{admin.email}"
                         fill_in "password", with: "password"
                         fill_in "Confirm Password", with: "password"
                         click_on(class: 'login-btn')
                         expect(page).to have_content("Welcome Back!")
                         expect(page).to have_content("#{admin.first_name} #{admin.last_name}")}
    let(:sign_in_user){ click_link "Login"
                        fill_in "Email", with: "#{user.email}"
                        fill_in "password", with: "password"
                        fill_in "Confirm Password", with: "password"
                        click_on(class: 'login-btn')
                        expect(page).to have_content("Welcome Back!")
                        expect(page).to have_content("#{user.first_name} #{user.last_name}")}

    let(:company_name){"New Company"}
    let(:url){"www.companyname.com"}
    let(:blurb){"Blah blah blah"}
    let(:twitter){"www.twitter.com/companyname"}

    before do
      visit root_path
    end

    context 'Admin' do
      before do
        spotlight
        sign_in_admin
      end
      scenario 'add new' do
        expect(page).to have_link(class: 'add-new-spotlight-btn')
        click_on(class: 'add-new-spotlight-btn')
        expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
        expect(page).to have_content("Home")
        expect(page).to have_content("Add New Spotlight")
        fill_in "Company name", with: company_name
        fill_in "Url", with: url
        fill_in "Blurb", with: blurb
        fill_in "Twitter", with: twitter
        expect{click_on "Create Spotlight"}.to change(Spotlight, :count).by(1)
        expect(page).to have_content("success! New Spotlight Added Successfully!")
        expect(page).to have_content("SPOTLIGHT INDEX")
        expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
        expect(page).to have_content("Home")
        expect(page).to have_content("SPOTLIGHT INDEX")
        expect(page).to have_content(company_name)
        expect(page).to have_content(blurb)
      end

      scenario 'unable to add new' do
        expect(page).to have_link(class: 'add-new-spotlight-btn')
        click_on(class: 'add-new-spotlight-btn')
        expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
        expect(page).to have_content("Home")
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

      scenario 'update' do
        old_blurb = spotlight.blurb
        new_blurb = "This is a new blurb all about that company"
        expect(page).to have_content(old_blurb)
        expect(page).to have_link(class: 'edit-btn')
        click_on(class: 'edit-btn')
        expect(page).to have_content("Edit Spotlight")
        fill_in "Blurb", with: new_blurb
        click_on "Update Spotlight"
        expect(page).to have_content(new_blurb)
        expect(page).not_to have_content(old_blurb)
        expect(page).to have_content("SPOTLIGHT INDEX")
      end

      scenario 'unable to update' do
        old_blurb = spotlight.blurb
        new_blurb = "%"
        expect(page).to have_content(old_blurb)
        expect(page).to have_link(class: 'edit-btn')
        click_on(class: 'edit-btn')
        expect(page).to have_content("Edit Spotlight")
        fill_in "Blurb", with: new_blurb
        click_on "Update Spotlight"
        expect(page).to have_content("error! Unable to Update Spotlight - See Form For Errors")
        expect(page).to have_content("Blurb is too short (minimum is 10 characters)")
        expect(page).to have_content(new_blurb)
      end

      scenario 'delete article' do
        expect(page).to have_content(spotlight.blurb)
        expect(page).to have_content("Delete")
        expect(page).to have_link(class: 'delete-btn')
        expect{ click_link "Delete" }.to change(Spotlight, :count).by(-1)
        expect(page).to have_content("Spotlight Deleted Successfully")
        expect(page).to have_content("SPOTLIGHT INDEX")
        expect(page).not_to have_content(spotlight.blurb)
      end

      scenario 'see show page for more info about company' do
        spotlight = create(:spotlight, description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
        visit root_path
        expect(page).to have_content(spotlight.blurb)
        expect(page).to have_link(class: 'show-btn')
        click_link(class: 'show-btn')
        expect(page).to have_content(spotlight.description)
      end
    end

    context 'User' do
      before :each do
        spotlight
        sign_in_user
        expect(page).to have_content(spotlight.blurb)
      end
      scenario 'No option to add new' do
        expect(page).not_to have_link(class: 'add-new-spotlight-btn')
        first(class: "spotlights-link").click
        expect(page).to have_content("SPOTLIGHT INDEX")
        expect(page).to have_content(spotlight.blurb)
        expect(page).not_to have_link(class: 'add-new-spotlight-btn')
      end

      scenario 'No option to update' do
        expect(page).not_to have_link(class: 'edit-btn')
        first(class: "spotlights-link").click
        expect(page).to have_content("SPOTLIGHT INDEX")
        expect(page).to have_content(spotlight.blurb)
        expect(page).not_to have_link(class: 'edit-btn')
      end

      scenario 'No option to delete' do
        expect(page).not_to have_link(class: "delete-btn")
        first(class: 'spotlights-link').click
        expect(page).to have_content("SPOTLIGHT INDEX")
        expect(page).to have_content(spotlight.blurb)
        expect(page).not_to have_link(class: "delete-btn")
      end

      scenario 'saving and removing an article' do
        find('.save-btn', text: 'Save')
        click_link(class: 'save-btn')
        find('.save-btn', text: 'Remove')
        expect(page).to have_link(class: 'save-btn')
        click_link(class: 'saved-spotlight-index')
        expect(page).to have_content("Your Saved Spotlight Links")
        expect(page).to have_content(spotlight.blurb)
        find('.save-btn', text: 'Remove')
        click_link(class: 'save-btn')
        expect(page).not_to have_content(spotlight.blurb)
        click_link(class: "home-link")
        expect(page).to have_content(spotlight.blurb)
        find('.save-btn', text: 'Save')
        expect(page).not_to have_content("Remove")
      end

      scenario 'see show page for more info about company' do
        spotlight = create(:spotlight, description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
        visit root_path
        expect(page).to have_content(spotlight.blurb)
        expect(page).to have_link(class: 'show-btn')
        click_link(class: 'show-btn')
        expect(page).to have_content(spotlight.description)
      end
    end

    context 'non-user' do
      scenario 'no option to edit' do
        spotlights = create_list(:spotlight, 3)
        visit root_path
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'edit-btn')
        first(class: 'spotlights-link').click
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'edit-btn')
      end

      scenario 'no option to save' do
        spotlights = create_list(:spotlight, 3)
        visit root_path
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'save-btn')
        first(class: 'spotlights-link').click
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'save-btn')
      end

      scenario 'no option to delete' do
        spotlights = create_list(:spotlight, 3)
        visit root_path
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'delete-btn')
        first(class: 'spotlights-link').click
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'delete-btn')
      end

      scenario 'no option to create new' do
        spotlights = create_list(:spotlight, 3)
        visit root_path
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'add-new-spotlight-btn')
        first(class: 'spotlights-link').click
        expect(page).to have_content(spotlights.first.blurb)
        expect(page).not_to have_link(class: 'add-new-spotlight-btn')
      end

      scenario 'search' do
        spotlights = create_list(:spotlight, 3)
        visit root_path
        first(class: 'spotlights-link').click
        expect(page).to have_content("SPOTLIGHT INDEX")
        fill_in "spotlight_query", with: spotlights.last.name
        click_on("Search")
        expect(page).to have_content("Spotlight Search Index")
        expect(page).to have_content(spotlights.last.company_name)
        expect(page).to have_content(spotlights.last.blurb)
      end

      scenario 'see show page for more info about company' do
        spotlight = create(:spotlight, description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
        visit root_path
        expect(page).to have_content(spotlight.blurb)
        expect(page).to have_link(class: 'show-btn')
        click_link(class: 'show-btn')
        expect(page).to have_content(spotlight.description)
      end
    end

end
