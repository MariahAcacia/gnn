require 'rails_helper'

describe 'SpotlightRequests' do

  let(:spotlight){ create(:spotlight) }

  describe 'Admin Access' do
    let(:admin){ create(:user, admin: true) }

    before :each do
      post session_path, params: { email: admin.email, password: admin.password, password_confirmation: admin.password }
    end

    describe 'GET #index' do
      it 'works as normal' do
        get spotlights_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_spotlight_path
      end
      it 'works as normal' do
        expect(response).to be_successful
      end
      it 'renders new form' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid inputs' do
        it 'actually creates a new spotlight record' do
          expect{ post spotlights_path, params: { spotlight: attributes_for(:spotlight) } }.to change(Spotlight, :count).by(1)
        end
        before :each do
          post spotlights_path, params: { spotlight: attributes_for(:spotlight) }
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects you to index page' do
          expect(response).to redirect_to spotlights_path
        end
      end
      context 'with invalid inputs' do
        it 'does not actually create a new record' do
          expect{ post spotlights_path, params: { spotlight: attributes_for(:spotlight, name: '', company_name: '') } }.to change(Spotlight, :count).by(0)
        end
        before :each do
          post spotlights_path, params: { spotlight: attributes_for(:spotlight, name: '', company_name: '') }
        end
        it 'creates and error flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 're renders new form with errors' do
          expect(response).to render_template :new
        end
      end
    end

    describe 'GET #show' do
      it 'works as normal' do
        get spotlight_path(spotlight)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_spotlight_path(spotlight)
      end
      it 'works as normal' do
        expect(response).to be_successful
      end
      it 'renders edit form' do
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      context 'with valid inputs' do
        let(:new_name){ "Bob Burger" }
        before :each do
          patch spotlight_path(spotlight), params: { spotlight: attributes_for(:spotlight, name: new_name) }
        end
        it 'actually updates spotlight record' do
          spotlight.reload
          expect(spotlight.name).to eq(new_name)
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to index page' do
          expect(response).to redirect_to spotlights_path
        end
      end
      context 'with invalid inputs' do
        let(:new_name){ nil }
        let(:new_co_name){ nil }
        before :each do
          spotlight
          patch spotlight_path(spotlight), params: { spotlight: attributes_for(:spotlight, name: new_name, company_name: new_co_name) }
        end
        it 'does not update spotlight record' do
          expect(spotlight.name).not_to be_nil
        end
        it 'creates flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it "render edit form with errors" do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'actually destroys record' do
        spotlight = create(:spotlight)
        expect{ delete spotlight_path(spotlight) }.to change(Spotlight, :count).by(-1)
      end
      before :each do
        delete spotlight_path(spotlight)
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects you to index page' do
        expect(response).to redirect_to spotlights_path
      end
    end

  end

  describe 'User Access' do
    let(:user){ create(:user) }

    before :each do
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end

    describe 'GET #index' do
      it 'works as normal' do
        get spotlights_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_spotlight_path
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/^You must be an Admin to access/)
      end
    end

    describe 'POST #create' do
      it 'does not create new record' do
        expect{ post spotlights_path, params: { spotlight: attributes_for(:spotlight) } }.to change(Spotlight, :count).by(0)
      end
      before :each do
        post spotlights_path, params: { spotlight: attributes_for(:spotlight) }
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/^You must be an Admin to access/)
      end
    end

    describe 'GET #show' do
      it 'works as normal' do
        get spotlight_path(spotlight)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_spotlight_path(spotlight)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/^You must be an Admin to access/)
      end
    end

    describe 'PATCH #update' do
      before :each do
        new_co_name = "New Company Name"
        patch spotlight_path(spotlight), params: { spotlight: attributes_for(:spotlight, company_name: new_co_name) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'does not update record' do
        expect(spotlight.company_name).not_to eq("New Company Name")
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/You must be an Admin to access/)
      end
    end

    describe 'DELETE #destroy' do
      it 'does not actually delete record' do
        spotlight = create(:spotlight)
        expect{ delete spotlight_path(spotlight) }.to change(Spotlight, :count).by(0)
      end
      before :each do
        spotlight = create(:spotlight)
        delete spotlight_path(spotlight)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/You must be an Admin to access/)
      end
    end

  end

  describe 'Non-User Access' do

    describe 'GET #index' do
      it 'works as normal' do
        get spotlights_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_spotlight_path
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/Please sign in to access!/)
      end
    end

    describe 'POST #create' do
      it 'does not create new record' do
        expect{ post spotlights_path, params: { spotlight: attributes_for(:spotlight) } }.to change(Spotlight, :count).by(0)
      end
      before :each do
        post spotlights_path, params: { spotlight: attributes_for(:spotlight) }
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/Please sign in to access!/)
      end
    end

    describe 'GET #show' do
      it 'restricts access' do
        get spotlight_path(spotlight)
        expect(response).not_to be_successful
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_spotlight_path(spotlight)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/Please sign in to access!/)
      end
    end

    describe 'PATCH #update' do
      before :each do
        new_co_name = "New Company Name"
        patch spotlight_path(spotlight), params: { spotlight: attributes_for(:spotlight, company_name: new_co_name) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'does not update record' do
        expect(spotlight.company_name).not_to eq("New Company Name")
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/Please sign in to access!/)
      end
    end

    describe 'DELETE #destroy' do
      it 'does not actually delete record' do
        spotlight = create(:spotlight)
        expect{ delete spotlight_path(spotlight) }.to change(Spotlight, :count).by(0)
      end
      before :each do
        spotlight = create(:spotlight)
        delete spotlight_path(spotlight)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message' do
        expect(flash[:error]).to match(/Please sign in to access!/)
      end
    end


  end
end
