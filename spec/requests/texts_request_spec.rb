require 'rails_helper'

describe 'TextRequests' do

  let(:text){ create(:text) }

  describe 'User Access' do

    let(:user){ create(:user) }

    before :each do
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end

    describe "GET #index" do
      it 'works as normal' do
        get texts_path
        expect(response).to be_successful
      end
    end

    describe 'GET #search_index' do
      it 'works as normal' do
        text
        get text_search_path, params: { text_query: text.blurb.partition(" ").first }
        expect(response).to be_successful
      end
    end

    describe 'GET #saved_index' do
      it 'works as normal' do
        get text_saved_path
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      before :each do
        get new_text_path
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message that you do not have access' do
        expect(flash[:error]).not_to be_nil
      end
    end

    describe "POST #create" do
      it 'does not actually create a new text' do
        expect { post texts_path, params: { :text => attributes_for(:text) } }.to change(Text,:count).by(0)
      end
      before :each do
        post texts_path, params: { :text => attributes_for(:text) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message that you do not have access' do
        expect(flash[:error]).not_to be_nil
      end
    end

    describe "GET #edit" do
      before :each do
        get edit_text_path(text)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message that you do not have access' do
        expect(flash[:error]).not_to be_nil
      end
    end

    describe "PATCH #update" do
      before :each do
        patch text_path(text), params: { text: attributes_for(:text) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message that you do not have access' do
        expect(flash[:error]).not_to be_nil
      end
    end

    describe "DELETE #destroy" do
      it 'does not actually delete text' do
        expect {delete text_path(text)}.to change(Text, :count).by(0)
      end
      before :each do
        delete text_path(text)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'redirects home page' do
        expect(response).to redirect_to root_path
      end
      it 'creates flash message that you do not have access' do
        expect(flash[:error]).not_to be_nil
      end
    end

  end

  describe 'Admin Access' do

    let(:admin){ create(:user, admin: true) }

    before :each do
      post session_path, params: { email: admin.email, password: admin.password, password_confirmation: admin.password }
    end

    describe "GET #index" do
      it 'works as normal' do
        get texts_path
        expect(response).to be_successful
      end
    end

    describe 'GET #search_index' do
      it 'works as normal' do
        text
        get text_search_path, params: { text_query: text.blurb.partition(" ").first }
        expect(response).to be_successful
      end
    end

    describe 'GET #saved_index' do
      it 'works as normal' do
        get text_saved_path
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it 'works as normal' do
        get new_text_path
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'actually creates new text object' do
        expect{ post texts_path, params: { text: attributes_for(:text) } }.to change(Text, :count).by(1)
      end

      before :each do
        post texts_path, params: { text: attributes_for(:text) }
      end

      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects yout to index' do
        expect(response).to redirect_to texts_path
      end
    end

    describe "GET #edit" do
      it 'works as normal' do
        get edit_text_path(text)
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      before :each do
        patch text_path(text), params: { :text => attributes_for(:text, headline: new_headline ) }
      end
      context 'with valid attributes' do
        let(:new_headline){ "I Am A NEW Headline" }

        it 'actually updates the text object' do
          text.reload
          expect(text.headline).to eq(new_headline)
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects you to index page' do
          expect(response).to redirect_to texts_path
        end
      end
      context 'with invalid attributes' do
        let(:new_headline){ "" }
        before :each do
          patch text_path(text), params: { :text => attributes_for(:text, headline: new_headline ) }
        end
        it 'does not update object' do
          text.reload
          expect(text.headline).not_to eq(new_headline)
        end
        it 'creates flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 'renders edit form' do
          expect(response.body).to match /Edit Text Article/
        end
      end
    end

    describe "DELETE #destroy" do
      it 'actually destroys text object' do
        text
        expect{ delete text_path(text) }.to change(Text, :count).by(-1)
      end
      it 'creates flash message' do
        delete text_path(text)
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects to index page' do
        delete text_path(text)
        expect(response).to redirect_to texts_path
      end
    end

  end

  describe 'Non-User Access' do

    describe 'GET #index' do
      it 'works as normal' do
        get texts_path
        expect(response).to be_successful
      end
    end

    describe 'GET #search_index' do
      it 'works as normal' do
        text
        get text_search_path, params: { text_query: text.blurb.partition(" ").first }
        expect(response).to be_successful
      end
    end

    describe 'GET #saved_index' do
      before do
        get text_saved_path
      end
      it 'denies access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #new' do
      before :each do
        get new_text_path
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'does not actually create a new text object' do
        expect{ post texts_path, params: { text: attributes_for(:text) } }.to change(Text, :count).by(0)
      end
      before :each do
        post texts_path, params: { text: attributes_for(:text) }
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      before :each do
        get edit_text_path(text)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'PATCH #update' do
      let(:new_headline){ "I am A NEW Headline" }
      before :each do
        patch text_path(text), params: { :text => attributes_for(:text, headline: new_headline ) }
      end
      it 'does not actually update the text article' do
        text.reload
        expect(text.headline).not_to eq(new_headline)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destroy' do
      it 'does NOT actually delete text article' do
        text
        expect{ delete text_path(text) }.to change(Text, :count).by(0)
      end
      before :each do
        delete text_path(text)
      end
      it 'restricts access' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

  end

end
