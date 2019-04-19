require 'rails_helper'

describe Video do

  let(:video){ create(:video) }
  let(:second_vid){ create(:video) }


  describe 'Attributes' do
    it 'is valid with valid attributes' do
      expect(video).to be_valid
    end

    it 'is invalid with invalid attributes' do
      new_vid = build(:video, headline: '', blurb: '', url: '')
      expect(new_vid).not_to be_valid
    end
  end

  describe 'Validations' do
    it 'is not valid without headline' do
      vid = build(:video, headline: '')
      expect(vid).not_to be_valid
    end
    it 'is not valid without blurb' do
      vid = build(:video, blurb: '')
      expect(vid).not_to be_valid
    end
    it 'is not valid without url' do
      vid = build(:video, url: '')
      expect(vid).not_to be_valid
    end
    it 'is valid without photo' do
      vid = build(:video)
      expect(vid).to be_valid
    end
    it 'is valid with photo'
  end

  describe 'Methods' do
    describe "#newest_four" do
      it 'saves the latest four articles in an instance variable' do
        video
        second_vid
        third = create(:video)
        forth = create(:video)
        fifth = create(:video)
        videos = Video.newest_four
        expect(videos).to eq([fifth, forth, third, second_vid])
      end
    end
  end

  describe 'User Associations' do
    it 'responds to users saved' 
  end

end
