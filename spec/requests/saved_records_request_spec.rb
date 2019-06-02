require 'rails_helper'

describe 'SavedRecordRequests' do

  let(:text){ create(:text) }
  let(:admin){ create(:user, admin: true) }
  let(:user){ create(:user) }

  context 'Admin Access' do
    before :each do
      admin
      post session_path, params: { email: admin.email, password: admin.password, password_confirmation: admin.password }
    end

    describe 'POST #create' do
      it 'actually creates saved record' do
        puts "admin saved: #{SavedRecord.count}"
        expect{ post saved_record_path, params: { save: { user_id: admin.id, saveable_id: text.id, saveable_type: 'Text'} } }.to change(SavedRecord, :count).by(1)
        puts "admin after saved: #{SavedRecord.count}"
      end
      before :each do
        saved_record = create(:saved_record, user_id: admin.id)
        post saved_record_path, params: { save: attributes_for(:saved_record) }
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects back to same page' do
        expect(response).to be_redirect
      end
    end

    describe 'DELETE #destroy' do
      it 'actually deletes record' do
        saved_record = create(:saved_record, user_id: admin.id)
        expect{ delete saved_record_path, params: { save: { user_id: saved_record.user_id, saveable_id: saved_record.saveable_id, saveable_type: saved_record.saveable_type} } }.to change(SavedRecord, :count).by(-1)
      end
      before :each do
        saved_record = create(:saved_record, user_id: admin.id)
        delete saved_record_path, params: { save: { user_id: saved_record.user_id, saveable_id: saved_record.saveable_id, saveable_type: saved_record.saveable_type} }
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects back to same page' do
        expect(response).to be_redirect
      end
    end
  end

  context 'Non User Access' do
    describe 'POST #create' do
      it 'does not actually create new record' do
        text = create(:text)
        expect{ post saved_record_path, params: { save: { user_id: user, saveable_id: text.id, saveable_type: "Text" } } }.not_to change(SavedRecord, :count)
      end
      before do
        text = create(:text)
        post saved_record_path, params: { save: { user_id: user.id, saveable_id: text.id, saveable_type: "Text" } }
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects to home' do
        expect(response).to redirect_to root_path
      end
    end
    describe 'DELETE #destroy' do
      it 'does not actually delete record' do
        saved = create(:saved_record)
        expect{ delete saved_record_path, params: { save: { user_id: saved.user_id, saveable_id: saved.saveable_id, saveable_type: saved.saveable_type } } }.not_to change(SavedRecord, :count)
      end
      before do
        saved = create(:saved_record)
        delete saved_record_path, params: { save: { user_id: saved.user_id, saveable_id: saved.saveable_id, saveable_type: saved.saveable_type } }
      end
      it 'creates flash message' do
        expect(flash[:error]).not_to be_nil
      end
      it 'redirects back to home page' do
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'User Access' do
    before do
      user
      post session_path, params: { email: user.email, password: user.password, password_confirmation: user.password }
    end
    describe 'POST #create' do
      it 'actuallly creates a saved record' do
        new_video = create(:video)
        expect{ post saved_record_path, params: { save: { user_id: user.id, saveable_id: new_video.id, saveable_type: "Video" } } }.to change(SavedRecord, :count).by(1)
      end
      before do
        another_video = create(:video)
        post saved_record_path, params: { save: { user_id: user.id, saveable_id: another_video.id, saveable_type: "Video" } }
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects back to same page' do
        expect(response).to be_redirect
      end
    end

    describe 'DELETE #destroy' do
      it 'actually deletes saved record' do
        saved = create(:saved_record)
        expect{ delete saved_record_path, params: { save: { user_id: saved.user_id, saveable_id: saved.saveable_id, saveable_type: saved.saveable_type } } }.to change(SavedRecord, :count).by(-1)
      end
      before do
        saved = create(:saved_record)
        delete saved_record_path, params: { save: { user_id: saved.user_id, saveable_id: saved.saveable_id, saveable_type: saved.saveable_type } }
      end
      it 'creates flash message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects to same page' do
        expect(response).to be_redirect
      end
    end
  end

end
