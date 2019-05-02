require 'rails_helper'

describe Spotlight do

  let(:spotlight){ create(:spotlight) }

  describe 'attributes' do
    it 'with valid inputs is valid' do
      expect(spotlight).to be_valid
    end
    it 'with invalid inputs is invalid' do
      new_spotlight = build(:spotlight, url: "", blurb: "", company_name: "", name: "")
      expect(new_spotlight).not_to be_valid
    end
  end

  describe 'validations' do
    it 'is valid with a company name and a first and last name' do
      new_spotlight = build(:spotlight, company_name: "Company", name: "First LastName")
      expect(new_spotlight).to be_valid
    end
    it 'is valid with a company name and no first and last name' do
      new_spotlight = build(:spotlight, name: "")
      expect(new_spotlight).to be_valid
    end
    it 'is valid with a first and last name and no company name' do
      new_spotlight = build(:spotlight, company_name: "")
      expect(new_spotlight).to be_valid
    end
    it 'is invalid with out a company name or a first and last name' do
      new_spotlight = build(:spotlight, company_name: '', name: '')
      expect(new_spotlight).not_to be_valid
    end
    it 'without url is invalid' do
      new_spotlight = build(:spotlight, url: "")
      expect(new_spotlight).not_to be_valid
    end
    it 'without blurb it is invalid' do
      new_spotlight = build(:spotlight, blurb: "")
      expect(new_spotlight).not_to be_valid
    end

  end

  describe 'methods' do
    describe '#newest_four' do
      it 'returns the newest (most recently added) spotlights' do
        spotlight
        one = create(:spotlight)
        two = create(:spotlight)
        three = create(:spotlight)
        four = create(:spotlight)
        five = create(:spotlight)
        newest = Spotlight.newest_four
        expect(newest).to eq([five,four,three,two])
      end
    end
  end

  describe 'user associations' do
    it 'responds to saved by users'
  end

end
