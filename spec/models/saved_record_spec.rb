require 'rails_helper'

describe SavedRecord do

  let(:user){ create(:user) }
  let(:text){ create(:text) }
  let(:video){ create(:video) }
  let(:spotlight){ create(:spotlight) }
  let(:giving){ create(:giving) }
  let(:saved){ create(:saved_record) }

  describe 'attributes' do
    it 'has a user id' do
      expect(saved).to respond_to(:user_id)
    end
    it 'has a saveable id' do
      expect(saved).to respond_to(:saveable_id)
    end
    it 'has a saveable type' do
      expect(saved).to respond_to(:saveable_type)
    end
  end

  describe 'validations' do
    describe 'saveable_type' do
      it 'Text is valid' do
        saved_text = build(:saved_record, user_id: user.id, saveable_id: text.id, saveable_type: "Text")
        expect(saved_text).to be_valid
      end
      it 'Video is valid' do
        saved_video = build(:saved_record, user_id: user.id, saveable_id: video.id, saveable_type: "Video")
        expect(saved_video).to be_valid
      end
      it 'Spotlight is valid' do
        saved_spotlight = build(:saved_record, user_id: user.id, saveable_id: spotlight.id, saveable_type: "Spotlight")
        expect(saved_spotlight).to be_valid
      end
      it 'Giving is valid' do
        saved_giving = build(:saved_record, user_id: user.id, saveable_id: giving.id, saveable_type: "Giving")
        expect(saved_giving).to be_valid
      end
      it 'noting else is valid' do
        invalid_save = build(:saved_record, user_id: user.id, saveable_id: text.id, saveable_type: '')
        expect(invalid_save).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(saved).to respond_to(:user)
    end
    it 'belongs to an article' do
      expect(saved).to respond_to(:saveable)
    end
  end

end
