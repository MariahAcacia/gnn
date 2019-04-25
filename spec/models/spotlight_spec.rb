require 'rails_helper'

describe Spotlight do

  let(:spotlight){ create(:spotlight) }

  describe 'attributes' do
    it 'with valid inputs is valid' do
      expect(spotlight).to be_valid
    end
    it 'with invalid inputs is invalid' do
      new_spotlight = build(:spotlight, url: "", blurb: "")
      expect(new_spotlight).not_to be_valid
    end
  end

  describe 'validations' do
    it 'must have a company name or a first and last name'
    it 'must have url to be valid'
    it 'must have blurb to be valid'

  end

  describe 'methods' do
  end

  describe 'user associations' do
    it 'responds to saved by users'
  end

end
