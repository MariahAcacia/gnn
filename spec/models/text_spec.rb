require 'rails_helper'
require 'factory_bot'

describe Text do

  let(:text){ create(:text) }
  let(:second_text){ create(:text) }

  describe "attributes" do
    it 'is valid with valid attributes' do
      expect(text).to be_valid
    end

    it 'is invalid with invalid attributes' do
      new_text = build(:text, headline: '', blurb: '', website: '')
      expect(new_text).not_to be_valid
    end
  end

  describe 'validations' do
    it 'is not valid without a headline' do
      new_text = build(:text, headline: "")
      expect(new_text).not_to be_valid
    end

    it 'is not valid without a website' do
      new_text = build(:text, website: "")
      expect(new_text).not_to be_valid
    end

    it 'is not valid without a blurb' do
      new_text = build(:text, blurb: "")
      expect(new_text).not_to be_valid
    end
  end

  describe "methods" do
    describe '#newest_four' do
      it 'saves newest four articles in an instance variable' do
        text
        second_text
        third_text = create(:text)
        forth_text = create(:text)
        fifth_text = create(:text)
        texts = Text.newest_four
        expect(texts).to eq([text,second_text,third_text,forth_text])
      end
    end
  end

  describe "user associations" do
    it 'responds to users saved'
  end

end