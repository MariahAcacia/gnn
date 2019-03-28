require 'rails_helper'

describe "SessionRequest" do

  describe "session access" do
    let(:user) { create(:user) }

    describe "GET #login" do
      it 'works as normal' do
        get login_path
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      before :each do
        post session_path, params: { email: user.email,
                                  password: user.password,
                     password_confirmation: user.password }
      end

      it 'actually logs you in by creating a cookie' do
        user.reload
        expect(cookies[:auth_token]).to eq(user.auth_token)
      end

      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end

      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe "DELETE #destroy" do
      before :each do
        post session_path, params: { email: user.email,
                                  password: user.password,
                     password_confirmation: user.password,
                                first_name: user.first_name,
                                 last_name: user.last_name }
        delete session_path
      end
      it 'actually logs you out by deleting session' do
        expect(session[:user_id]).to be_nil
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

  end

end
