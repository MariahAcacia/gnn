require 'rails_helper'

describe 'VideoRequests' do

  let(:video){ create(:video) }

  describe 'User Access' do

    let(:user){ create(:user) }

    before :each do
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end

    describe 'GET #index'do
      it 'works as normal' do
        get videos_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_video_path
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'does not create a new video object' do
        expect{ post videos_path, params: { video: attributes_for(:video) } }.to change(Video, :count).by(0)
      end
      before :each do
        post videos_path, params: { video: attributes_for(:video) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #show' do
      it 'works as normal' do
        get video_path(video)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_video_path(video)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'PATCH #update' do
      let(:old_headline){ video.headline }
      let(:new_headline){ "" }
      before :each do
        patch video_path(video), params: { video: attributes_for(:video, headline: new_headline) }
      end
      it 'does not actually update video record' do
        expect(video.headline).to eq(old_headline)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destroy' do
      it 'does not actually delete video record' do
        video
        expect{ delete video_path(video) }.not_to change(Video, :count)
      end
      before :each do
        video
        delete video_path(video)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end
  end


  describe 'Admin Access' do

    let(:admin){ create(:user, admin: true) }

    before :each do
      post session_path, params: { email: admin.email, password: admin.password, password_confirmation: admin.password }
    end

    describe 'GET #index'do
      it 'works as normal' do
        get videos_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'works as normal' do
        get new_video_path
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        let(:headline){ "I am a NEW Headline" }
        it 'actually creates video object' do
          expect{ post videos_path, params: { video: attributes_for(:video, headline: headline) } }.to change(Video, :count).by(1)
        end
        before :each do
          post videos_path, params: { video: attributes_for(:video) }
        end
        it 'creates successful flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to index page' do
          expect(response).to redirect_to videos_path
        end
      end
      context 'with invalid attributes' do
        let(:headline){ "" }
        it 'does not create video object' do
          expect{ post videos_path, params: { video: attributes_for(:video, headline: headline) } }.to change(Video, :count).by(0)
        end
        before :each do
          post videos_path, params: { video: attributes_for(:video, headline: headline) }
        end
        it 'creates error flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 're renders new form with errors' do
          expect(response.body).to match /New Video Article/
        end
      end
    end

    describe 'GET #show' do
      it 'works as normal' do
        get video_path(video)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'works as normal' do
        get edit_video_path(video)
        expect(response).to be_successful
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        let(:blurb){ "I am a blurb about a headline" }
        before :each do
          video
          patch video_path(video), params: { video: attributes_for(:video, blurb: blurb) }
        end
        it 'actually updates video object' do
          video.reload
          expect(video.blurb).to eq(blurb)
        end
        it 'creates flash messages to know it was successful' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to index page' do
          expect(response).to redirect_to videos_path
        end
      end
      context 'with invalid attrtibutes' do
        let(:blurb){ "" }
        before :each do
          video
          patch video_path(video), params: { video: attributes_for(:video, blurb: blurb) }
        end
        it 'does not update video object' do
          expect(video.blurb).not_to eq(blurb)
        end
        it 'creates error flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 'renders edit form with errors' do
          expect(response.body).to match /Edit Video Article/
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'actually deletes record' do
        video
        expect{ delete video_path(video) }.to change(Video, :count).by(-1)
      end
      it 'creates successful flash message once deleted' do
        delete video_path(video)
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects to index page' do
        delete video_path(video)
        expect(response).to redirect_to videos_path
      end
    end
  end


  describe 'Non-User/Admin Access' do

    describe 'GET #index'do
      it 'works as normal' do
        get videos_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_video_path
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'does not create a new video record' do
        expect{ post videos_path, params: { video: attributes_for(:video) } }.to change(Video, :count).by(0)
      end
      before :each do
        post videos_path, params: { video: attributes_for(:video) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end
    describe 'GET #show' do
      before :each do
        get video_path(video)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end
    describe 'GET #edit' do
      before :each do
        get edit_video_path(video)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end
    describe 'PATCH #update' do
      let(:blurb){ "New Blurb yo yo"}
      before :each do
        patch video_path(video), params: { video: attributes_for(:video, blurb: blurb) }
      end
      it 'does not actually update video record' do
        expect(video.blurb).not_to eq(blurb)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end
    describe 'DELETE #destroy' do
      it 'does not delete video record' do
        video
        expect{ delete video_path(video) }.to change(Video, :count).by(0)
      end
      it 'restricts access' do
        delete video_path(video)
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        delete video_path(video)
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        delete video_path(video)
        expect(response).to redirect_to root_path
      end
    end
  end

end
