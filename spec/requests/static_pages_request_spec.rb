require 'rails_helper'

describe 'StaticPagesRequests' do

  let(:user){ create(:user) }

  context 'logged in' do

    before do
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end

    describe "GET #about" do
      it 'works as normal' do
        get about_path
        expect(response).to be_successful
      end
    end

    describe "GET #contact" do
      it 'works as normal' do
        get new_message_path
        expect(response).to be_successful
      end
    end

  end

  context 'not logged in' do

    describe "GET #about" do
      it 'works as normal' do
        get about_path
        expect(response).to be_successful
      end
    end

    describe "GET #contact" do
      it 'works as normal' do
        get new_message_path
        expect(response).to be_successful
      end
    end


  end



end
