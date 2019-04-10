require 'rails_helper'

describe 'UserRequests' do

  describe 'user access' do

    let(:user){ create(:user) }
    let(:new_user){ create(:user) }


    before :each do
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end

    describe "GET #home" do
      it 'works as normal when logged in' do
        get home_path
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it 'works as normal when logged in' do
        get user_path(user)
        expect(response).to be_successful
      end
      it 'denies access for another user' do
        get user_path(new_user)
        expect(response).to redirect_to root_path
      end
    end


    describe "GET #edit" do
      it 'works as normal when logged in' do
        get edit_user_path(user)
        expect(response).to be_successful
      end
      it 'denies access for another user' do
        get edit_user_path(new_user)
        expect(response).to redirect_to root_path
      end
    end


    describe "PATCH #update" do

      context "with valid attributes" do
        let(:new_name){ "Bob" }
        before :each do
          patch user_path(user), params: { :user => attributes_for(:user, first_name: new_name)}
        end
        it 'actually updates user info' do
          user.reload
          expect(user.first_name).to eq(new_name)
        end
        it 'creates flash message' do
          user.reload
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects you to show page' do
          user.reload
          expect(response).to redirect_to user_path(user)
        end
      end

      context "without valid attributes" do
        let(:invalid_name){ "B" }
        before :each do
          put user_path(user), params: { :user => attributes_for(:user, first_name: invalid_name)}
        end
        it 'does not update user info' do
          user.reload
          expect(user.first_name).not_to eq(invalid_name)
        end
        it 'creates flash message' do
          user.reload
          expect(flash[:error]).not_to be_nil
        end
        it 'renders edit form with errors' do
          user.reload
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE #destroy" do
      it 'actually deletes user' do
        expect{ delete user_path(user) }.to change(User, :count).by(-1)
      end
      it 'if successful redirects to root path' do
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
      it 'if successful creates flash message' do
        delete user_path(user)
        expect(flash[:success]).not_to be_nil
      end
    end


  end

  describe 'non-user access' do

    let(:user){ create(:user) }

    describe "GET #new" do
      it 'works as normal when not logged in' do
        get new_user_path
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context 'with valid attributes' do
        first_name = "Bob"
        last_name = "Burgers"
        email = "#{first_name}.#{last_name}@youknow.com"
        password = "password"

        it 'actually creates a new user' do
          expect{ post users_path, params: { user: attributes_for(:user,  email: email,
                                                                          first_name: first_name,
                                                                          last_name: last_name,
                                                                          password: password,
                                                                          password_confirmation: password) } }.to change(User, :count).by(1)
        end


        it 'creates a flash message' do
          post users_path, params: { user: attributes_for(:user,  email: email,
                                                                  first_name: first_name,
                                                                  last_name: last_name,
                                                                  password: password,
                                                                  password_confirmation: password) }
          expect(flash[:success]).not_to be_nil
        end
        it 'redirects you to profile/show page' do
          post users_path, params: { user: attributes_for(:user,  email: email,
                                                                  first_name: first_name,
                                                                  last_name: last_name,
                                                                  password: password,
                                                                  password_confirmation: password) }
          expect(response).to redirect_to user_path(User.find_by_email(email))
        end
      end
    end

    describe "GET #home" do
      it 'works as normal when not logged in' do
        get home_path
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      before :each do
        get user_path(user)
      end
      it 'does not allow access when not logged in' do
        expect(response).to_not be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe "GET #edit" do
      before :each do
        get edit_user_path(user)
      end
      it 'does not allow access when not logged in' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects you to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe "PATCH #update" do
      let(:new_name){ "Bob" }
      before :each do
        put user_path(user), params: { :user => attributes_for(:user, first_name: new_name)}
      end
      it 'does not allow access when not logged in' do
        expect(response).not_to be_successful
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    describe "DELETE #destroy" do
      before :each do
        user
      end
      it 'does not destroy user' do
        expect{ delete user_path(user) }.to change(User, :count).by(0)
      end
      before :each do
        delete user_path(user)
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end


  end

end
