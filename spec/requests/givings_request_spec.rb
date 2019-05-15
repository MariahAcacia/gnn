require 'rails_helper'

describe 'GivingRequests' do

  describe 'Admin Access' do

    let(:admin){ create(:user, admin: true) }
    let(:company){ create(:giving) }
    let(:new_co_name){ "New Company" }
    let(:bad_blurb){ "bad" }

    before :each do
      post session_path, params: { email: admin.email, password: admin.password, password_confirmation: admin.password }
    end

    describe 'GET #index' do
      it 'works as normal' do
        get givings_path
        expect(response).to be_successful
      end
    end
    describe 'GET #search_index' do
      it 'works as normal'
    end
    describe 'GET #new' do
      before :each do
        get new_giving_path
      end
      it 'works as normal' do
        expect(response).to be_successful
      end
      it 'renders new form' do
        expect(response).to render_template :new
      end
    end
    describe 'POST #create' do
      context 'successful' do
        it 'actually creates a new record' do
          expect{ post givings_path, params: { giving: attributes_for(:giving) } }.to change(Giving, :count).by(1)
        end
        before :each do
          post givings_path, params: { giving: attributes_for(:giving) }
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to index page' do
          expect(response).to redirect_to givings_path
        end
      end
      context 'unsuccessful' do
        it 'does not create new record' do
          expect{ post givings_path, params: { giving: attributes_for(:giving, blurb: bad_blurb) } }.to change(Giving, :count).by(0)
        end
        before :each do
          post givings_path, params: { giving: attributes_for(:giving, blurb: bad_blurb) }
        end
        it 'creates flash error message' do
          expect(flash[:error]).not_to be_nil
        end
        it 'render new form' do
          expect(response).to render_template :new
        end
      end
    end
    describe 'GET #edit' do
      before :each do
        get edit_giving_path(company)
      end
      it 'works as normal' do
        expect(response).to be_successful
      end
      it 'it renders edit form' do
        expect(response).to render_template :edit
      end
    end
    describe 'PATCH #update' do
      before :each do
        patch giving_path(company), params: { giving: attributes_for(:giving, company_name: new_co_name) }
      end
      context 'successful' do
        it 'actually updates record' do
          company.reload
          expect(company.company_name).to eq(new_co_name)
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to index page' do
          expect(response).to redirect_to givings_path
        end
      end
      context 'unsuccessful' do
        before :each do
          patch giving_path(company), params: { giving: attributes_for(:giving, blurb: bad_blurb) }
        end
        it 'does not update record' do
          expect(company.blurb).not_to eq(bad_blurb)
        end
        it 'creates error flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 'render edit form' do
          expect(response).to render_template :edit
        end
      end
    end
    describe 'DELETE #destroy' do
      it 'actually deletes record' do
        new_company = create(:giving)
        expect{ delete giving_path(new_company) }.to change(Giving, :count).by(-1)
      end
      before :each do
        new_co = create(:giving)
        delete giving_path(new_co)
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects to index page' do
        expect(response).to redirect_to givings_path
      end
    end

    describe 'GET #show' do
      it 'works as normal' do
        get giving_path(company)
        expect(response).to be_successful
      end
    end

    describe 'GET #search_index' do
      it 'works as normal' do
        get giving_search_path
        expect(response).to be_successful
      end
    end

  end

  describe 'User Access' do

    let(:new_user){ create(:user) }
    let(:company){ create(:giving) }
    let(:new_co_name){ "New Company" }
    let(:bad_blurb){ "bad" }

    before :each do
      post session_path, params: { email: new_user.email, password: new_user.password, password_confirmation: new_user.password }
    end

    describe 'GET #index' do
      it 'works as normal' do
        get givings_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_giving_path
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to index' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'does not create new record' do
        expect{ post givings_path, params: { giving: attributes_for(:giving) } }.to change(Giving, :count).by(0)
      end
      before :each do
        post givings_path, params: { giving: attributes_for(:giving) }
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to index' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_giving_path(company)
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'PATCH #update' do
      before :each do
        patch giving_path(company), params: { givings: attributes_for(:giving, company_name: new_co_name) }
      end
      it 'does not update record' do
        expect(company.company_name).not_to eq(new_co_name)
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #show' do
      it 'works as normal' do
        get giving_path(company)
        expect(response).to be_successful
      end
    end

    describe 'GET #search_index' do
      it 'works as normal' do
        get giving_search_path
        expect(response).to be_successful
      end
    end

  end

  describe 'Non User Access' do

    let(:company){ create(:giving) }
    let(:new_co_name){ "New Company" }
    let(:bad_blurb){ "bad" }

    describe 'GET #index' do
      it 'works as normal' do
        get givings_path
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      before :each do
        get new_giving_path
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to index' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'does not create new record' do
        expect{ post givings_path, params: { giving: attributes_for(:giving) } }.to change(Giving, :count).by(0)
      end
      before :each do
        post givings_path, params: { giving: attributes_for(:giving) }
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to index' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_giving_path(company)
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'PATCH #update' do
      before :each do
        company
        new_co_name
        patch giving_path(company), params: { givings: attributes_for(:giving, company_name: new_co_name) }
      end
      it 'does not update record' do
        expect(company.company_name).not_to eq(new_co_name)
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #show' do
      before :each do
        get giving_path(company)
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'creates flash error message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #search_index' do
      it 'works as normal' do
        get giving_search_path
        expect(response).to be_successful
      end
    end
  end

end
