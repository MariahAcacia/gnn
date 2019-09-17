require 'rails_helper'

describe 'MessageRequests' do

  describe 'User Access' do
    let(:user){ create(:user) }
    before :each do
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end

    describe 'GET #new' do
      before :each do
        get new_message_url
      end
      it 'works as normal' do
        expect(response).to be_successful
      end
      it 'renders form' do
        expect(response).to render_template(:new)
      end
    end

    describe 'POST #create' do
      context "with valid inputs" do
        it 'creates delayed job' do
          expect{ post create_message_path, params: { message: { email: user.email, name: user.name, body: 'I like or do not like this page' } } }.to change(Delayed::Job, :count).by(1)
        end
        before :each do
          post create_message_path, params: { message: { email: user.email, name: user.name, body: 'I like or do not like this page' } }
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to home page' do
          expect(response).to redirect_to root_path
        end
      end
      context "with invalid inputs" do
        before :each do
          post create_message_path, params: { message: { email: '', name: '', body:'' } }
        end
        it 'creates error flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 're-renders form' do
          expect(response).to render_template(:new)
        end
      end
    end

  end

  describe 'Non User Access' do

    describe 'GET #new' do
      before :each do
        get new_message_url
      end
      it 'works as normal' do
        expect(response).to be_successful
      end
      it 'renders form' do
        expect(response).to render_template(:new)
      end
    end

    describe 'POST #create' do
      context "with valid inputes" do
        before :each do
          post create_message_path, params: { message: { email: 'bob@burgers.com', name: 'Bob Burger', body: 'I like or do not like this page' } }
        end
        it 'creates flash message' do
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects to home page' do
          expect(response).to redirect_to root_path
        end
      end
      context "with invalid inputs" do
        before :each do
          post create_message_path, params: { message: { email: '', name: '', body:'' } }
        end
        it 'creates error flash message' do
          expect(flash[:error]).not_to be_nil
        end
        it 're-renders form' do
          expect(response).to render_template(:new)
        end
      end
    end

  end

end
