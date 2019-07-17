require 'rails_helper'

feature 'Video Articles' do

    let(:admin){ create(:user, admin: true) }
    let(:user){ create(:user) }
    let(:video){ create(:video) }
    let(:sign_in_admin){ click_link "Login"
                         fill_in "Email", with: "#{admin.email}"
                         fill_in "password", with: "password"
                         fill_in "Confirm Password", with: "password"
                         click_on(class: "login-btn")
                         expect(page).to have_content("#{admin.first_name} #{admin.last_name}")
                         expect(page).to have_content("Welcome to GNN, where all the news is good news!")
                         expect(page).to have_content("success! Welcome Back!")}
    let(:sign_in_user){ click_link "Login"
                        fill_in "Email", with: "#{user.email}"
                        fill_in "password", with: "password"
                        fill_in "Confirm Password", with: "password"
                        click_on(class: 'login-btn')
                        expect(page).to have_content("#{user.first_name} #{user.last_name}")
                        expect(page).to have_content("Welcome to GNN, where all the news is good news!")
                        expect(page).to have_content("success! Welcome Back!") }

    before do
      @videos = [create(:video)]
      visit root_path
    end

    context 'Admin' do
      before :each do
        sign_in_admin
      end
      scenario 'add new' do
        headline = Faker::TvShows::Simpsons.quote[0,30].strip
        blurb = Faker::TvShows::Simpsons.quote
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

      scenario 'cannot add new' do
        headline = ""
        blurb = ""
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

      scenario 'update' do
        new_headline = "I am a new headline"
        expect(page).to have_link class: 'edit-btn'
        click_link class: 'edit-btn'
        expect(page).to have_content("Edit Video Article")
        fill_in "Headline", with: new_headline
        click_button "Update Video"
        expect(page).to have_content("success! Video Article Updated Successfully!")
        expect(page).to have_content(new_headline)
        expect(page).to have_content("VIDEO INDEX")
      end


      scenario 'unable to update' do
        new_headline = ""
        expect(page).to have_link class: 'edit-btn'
        click_link class: 'edit-btn'
        expect(page).to have_content("Edit Video Article")
        fill_in "Headline", with: new_headline
        click_button "Update Video"
        expect(page).to have_content("error! Unable to Update Video Article - See Form For Errors")
        expect(page).to have_content("Edit Video Article")
        expect(page).to have_content("Headline can't be blank")
      end

      scenario 'delete' do
        expect(page).to have_link class: 'delete-btn'
        expect(page).to have_content(@videos.first.headline)
        expect(page).to have_content(@videos.first.blurb)
        expect{ click_link class: 'delete-btn' }.to change(Video, :count).by(-1)
        expect(page).to have_content("VIDEO INDEX")
        expect(page).not_to have_content(@videos.first.headline)
        expect(page).not_to have_content(@videos.first.blurb)
      end
    end

    context 'Users' do
      before :each do
        sign_in_user
      end
      scenario 'no option to add new' do
        expect(page).to have_content(@videos.first.headline)
        expect(page).not_to have_link class: 'add-new-video-btn'
        first(class: "videos-link").click
        expect(page).to have_content("VIDEO INDEX")
        expect(page).to have_content(@videos.first.headline)
        expect(page).not_to have_link class: 'add-new-video-btn'
      end

      scenario 'no option to delete' do
        expect(page).to have_content(@videos.first.headline)
        expect(page).not_to have_link class: 'delete-btn'
        first(class: 'videos-link').click
        expect(page).to have_content(@videos.first.blurb)
        expect(page).to have_content("VIDEO INDEX")
        expect(page).not_to have_link class: 'delete-btn'
      end

      scenario 'no option to edit' do
        expect(page).to have_content(@videos.first.headline)
        expect(page).not_to have_link class: 'edit-btn'
        first(class: 'videos-link').click
        expect(page).to have_content("VIDEO INDEX")
        expect(page).to have_content(@videos.first.headline)
        expect(page).not_to have_link class: 'edit-btn'
      end

      scenario 'save and remove video article' do
        expect(page).to have_content(@videos.first.headline)
        expect(page).to have_link(class: 'save-btn')
        click_link(class: 'save-btn')
        expect(page).to have_content(@videos.first.headline)
        find('.save-btn', text: 'Remove')
        click_link(class: 'saved-video-index')
        expect(page).to have_content("Your Saved Video Links")
        expect(page).to have_content(@videos.first.headline)
        find('.save-btn', text: 'Remove')
        click_link(class: 'save-btn')
        expect(page).to have_content("Your Saved Video Links")
        expect(page).not_to have_content(@videos.first.headline)
        click_on("Home")
        expect(page).to have_content(@videos.first.headline)
        find('.save-btn', text: "Save")
      end
    end

    context 'Non-users' do
      before :each do
        expect(page).to have_content("Welcome to GNN, where all the news is good news!")
        expect(page).to have_content(@videos.first.headline)
        expect(page).to have_content(@videos.first.blurb)
      end

      scenario 'no option to edit' do
        expect(page).not_to have_link class: 'edit-btn'
        first(class: 'videos-link').click
        expect(page).to have_content("VIDEO INDEX")
        expect(page).to have_content(@videos.first.headline)
        expect(page).not_to have_link class: 'edit-btn'
      end

      scenario 'no option to delete' do
        expect(page).not_to have_link class: 'delete-btn'
        first(class: 'videos-link').click
        expect(page).to have_content("VIDEO INDEX")
        expect(page).to have_content(@videos.first.headline)
        expect(page).to have_content(@videos.first.blurb)
        expect(page).not_to have_link class: 'delete-btn'
      end
      scenario 'no option to save' do
        expect(page).not_to have_link(class: 'save-btn')
        first(class: 'videos-link').click
        expect(page).to have_content("VIDEO INDEX")
        expect(page).to have_content(@videos.first.headline)
        expect(page).to have_content(@videos.first.blurb)
        expect(page).not_to have_link(class: 'save-btn')
      end

      scenario 'search' do
        first(class: 'videos-link').click
        expect(page).to have_content("VIDEO INDEX")
        fill_in "video_query", with: @videos.first.headline[0,5]
        click_on("Search")
        expect(page).to have_content("Video Search Index")
        expect(page).to have_content(@videos.first.headline)
        expect(page).to have_content(@videos.first.blurb)
      end
    end
end
