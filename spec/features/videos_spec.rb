require 'rails_helper'

feature 'Video Articles' do

    let(:admin){ create(:user, admin: true) }
    let(:user){ create(:user) }
    let(:video){ create(:video) }
    let(:sign_in_admin){ click_button "Sign In"
                         fill_in "Email", with: "#{admin.email}"
                         fill_in "password", with: "password"
                         fill_in "Confirm Password", with: "password"
                         click_button "Sign In"
                         expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
                         expect(page).to have_content("Welcome to GNN, where all the news is good news!")
                         expect(page).to have_content("success! Welcome Back!")}
    let(:sign_in_user){ click_button "Sign In"
                        fill_in "Email", with: "#{user.email}"
                        fill_in "password", with: "password"
                        fill_in "Confirm Password", with: "password"
                        click_button "Sign In"
                        expect(page).to have_content("#{user.first_name} #{user.last_name}")
                        expect(page).to have_content("Welcome to GNN, where all the news is good news!")
                        expect(page).to have_content("success! Welcome Back!") }

    before do
      video
      visit root_path
    end

    scenario 'add new video record' do
      headline = Faker::Simpsons.quote
      blurb = Faker::Simpsons.quote
      sign_in_admin
      expect(page).to have_content("Video")
      expect(page).to have_link class: 'add-new-video-btn'
      click_on class: 'add-new-video-btn'
      expect(page).to have_content("Add New Video Article")
      fill_in "Headline", with: headline
      fill_in "Blurb", with: blurb
      fill_in "Url", with: "www.simpsonsworld.com"
      expect{ click_button "Create Video" }.to change(Video, :count).by(1)
      expect(page).to have_content("success! Video Article Added Successfully!")
      expect(page).to have_content("VIDEO INDEX")
      expect(page).to have_content(headline)
      expect(page).to have_content(blurb)
      click_link class: 'home-link'
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(headline)
      expect(page).to have_content(blurb)
    end

    scenario 'cannot add new video record - invalid inputs' do
      headline = ""
      blurb = ""
      sign_in_admin
      expect(page).to have_content("Video")
      expect(page).to have_link class: 'add-new-video-btn'
      click_on class: 'add-new-video-btn'
      fill_in "Headline", with: headline
      fill_in "Blurb", with: blurb
      fill_in "Url", with: "www.simpsonsworld.com"
      expect{ click_button "Create Video" }.to change(Video, :count).by(0)
      expect(page).to have_content("error! Unable to Add Video Article")
      expect(page).to have_content("Add New Video Article")
    end

    scenario 'non-admins should not have option to add new record' do
      sign_in_user
      expect(page).not_to have_link class: 'add-new-video-btn'
      click_link class: "video-index-link"
      expect(page).to have_content("VIDEO INDEX")
      expect(page).not_to have_link class: 'add-new-video-btn'
    end

    scenario 'update video article' do
      new_headline = "I am a new headline"
      sign_in_admin
      expect(page).to have_link class: 'edit-btn'
      click_link class: 'edit-btn'
      expect(page).to have_content("Edit Video Article")
      fill_in "Headline", with: new_headline
      click_button "Update Video"
      expect(page).to have_content("success! Video Article Updated Successfully!")
      expect(page).to have_content(new_headline)
      expect(page).to have_content("VIDEO INDEX")
    end

    scenario 'unable to update video article invalid inputs' do
      new_headline = ""
      sign_in_admin
      expect(page).to have_link class: 'edit-btn'
      click_link class: 'edit-btn'
      expect(page).to have_content("Edit Video Article")
      fill_in "Headline", with: new_headline
      click_button "Update Video"
      expect(page).to have_content("error! Unable to Update Video Article - See Form For Errors")
      expect(page).to have_content("Edit Video Article")
      expect(page).to have_content("Headline can't be blank")
    end

    scenario 'users should not have option to edit article' do
      sign_in_user
      expect(page).not_to have_link class: 'edit-btn'
      click_link class: 'video-index-link'
      expect(page).to have_content("VIDEO INDEX")
      expect(page).not_to have_link class: 'edit-btn'
    end

    scenario 'non-admin/non-users should not have option to edit article' do
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(video.headline)
      expect(page).to have_content(video.blurb)
      expect(page).not_to have_link class: 'edit-btn'
      click_link class: 'video-index-link'
      expect(page).to have_content("VIDEO INDEX")
      expect(page).to have_content(video.headline)
      expect(page).not_to have_link class: 'edit-btn'
    end

    scenario 'admin able to delete video article' do
      sign_in_admin
      expect(page).to have_link class: 'delete-btn'
      expect(page).to have_content(video.headline)
      expect(page).to have_content(video.blurb)
      expect{ click_link class: 'delete-btn' }.to change(Video, :count).by(-1)
      expect(page).to have_content("VIDEO INDEX")
      expect(page).not_to have_content(video.headline)
      expect(page).not_to have_content(video.blurb)
    end

    scenario 'users should not have option to delete articles' do
      sign_in_user
      expect(page).to have_content(video.headline)
      expect(page).not_to have_link class: 'delete-btn'
      click_link class: 'video-index-link'
      expect(page).to have_content(video.blurb)
      expect(page).to have_content("VIDEO INDEX")
      expect(page).not_to have_link class: 'delete-btn'
    end

    scenario 'non-admin/non-users should not have option to delete articles' do
      expect(page).to have_content("Welcome to GNN, where all the news is good news!")
      expect(page).to have_content(video.headline)
      expect(page).to have_content(video.blurb)
      expect(page).not_to have_link class: 'delete-btn'
      click_link class: 'video-index-link'
      expect(page).to have_content("VIDEO INDEX")
      expect(page).to have_content(video.headline)
      expect(page).to have_content(video.blurb)
      expect(page).not_to have_link class: 'delete-btn'
    end

end