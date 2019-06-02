require 'rails_helper'

describe Text do

  let(:text){ create(:text) }
  let(:user){ create(:user) }
  let(:saved_text){ SavedRecord.create(user_id: user.id, saveable_id: text.id, saveable_type: text.class.to_s) }
  let(:second_text){ create(:text) }

  describe "attributes" do
    it 'is valid with valid attributes' do
      expect(text).to be_valid
    end

    it 'is invalid with invalid attributes' do
      new_text = build(:text, headline: '', blurb: '', url: '')
      expect(new_text).not_to be_valid
    end
  end

  describe 'validations' do
    it 'is not valid without a headline' do
      new_text = build(:text, headline: "")
      expect(new_text).not_to be_valid
    end

    it 'is not valid without a url' do
      new_text = build(:text, url: "")
      expect(new_text).not_to be_valid
    end

    it 'is not valid without a blurb' do
      new_text = build(:text, blurb: "")
      expect(new_text).not_to be_valid
    end
  end

  describe "methods" do
    describe '#newest_four' do
      it 'returns newest four articles' do
        text
        second_text
        third_text = create(:text)
        forth_text = create(:text)
        fifth_text = create(:text)
        texts = Text.newest_four
        expect(texts).to eq([fifth_text, forth_text, third_text, second_text])
      end
    end

    describe '#article_search' do
      it 'returns any article that matches keyword' do
        text
        keyword = text.blurb.partition(" ").last
        expect(Text.article_search(keyword)).to eq([text])
      end
    end
  end

  describe "associations" do
    it 'it responds to user_saves' do
      expect(text).to respond_to(:user_saves)
    end
    it 'responds to saved records' do
      expect(text).to respond_to(:saved_records)
    end
  end

end
