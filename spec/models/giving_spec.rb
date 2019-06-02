require 'rails_helper'

describe Giving do

  let(:company){ create(:giving) }
  let(:long_blurb){ "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }

  describe 'attributes' do
    it 'is valid with valid attributes' do
      expect(company).to be_valid
    end
    it 'is invalid with valid attributes' do
      new_co = build(:giving, blurb: nil)
      expect(new_co).not_to be_valid
    end
  end

  describe 'validates' do
    describe 'presence of' do
      it 'url' do
        new_co = build(:giving, url: nil)
        expect(new_co).not_to be_valid
        new_co = build(:giving, url: "www.notnil.com")
        expect(new_co).to be_valid
      end
      it 'blurb' do
        new_co = build(:giving, blurb: nil)
        expect(new_co).not_to be_valid
        new_co = build(:giving, blurb: "A not nil blurb should be valid")
        expect(new_co).to be_valid
      end
      it 'company name OR name' do
        new_co = build(:giving, company_name: nil, name: nil)
        expect(new_co).not_to be_valid
        new_co = build(:giving, company_name: 'The Good Company', name: nil)
        expect(new_co).to be_valid
        new_co = build(:giving, company_name: nil, name: 'Bobby Bobberton')
        expect(new_co).to be_valid
      end
    end
    describe 'length of' do
      describe 'blurb' do
        describe 'under 10 characters' do
          it 'is invalid' do
            new_co = build(:giving, blurb: '123456789')
            expect(new_co).not_to be_valid
          end
        end
        describe 'over 350 characters' do
          it 'is invalid' do
            new_co = build(:giving, blurb: long_blurb)
            expect(new_co).not_to be_valid
          end
        end
        describe '10 characters' do
          it 'is valid' do
            new_co = build(:giving, blurb: '1234567890')
            expect(new_co).to be_valid
          end
        end
        describe '350 characters' do
          it 'is valid' do
            new_co = build(:giving, blurb: long_blurb.first(350))
            expect(new_co).to be_valid
          end
        end
        describe 'between 10 and 350 characters' do
          it 'is valid' do
            new_co = build(:giving, blurb: 'This is a medium length blurb, should be valid. Yes?')
            expect(new_co).to be_valid
          end
        end
      end
    end
  end

  describe 'methods' do
    describe '#newest_four' do
      it 'saves newest four' do
        company
        second = create(:giving)
        third = create(:giving)
        forth = create(:giving)
        fifth = create(:giving)
        expect(Giving.newest_four).to eq([fifth, forth, third, second])
      end
    end
    describe '#company_search' do
      it 'returns companies that have a matching keyword' do
        company
        keyword = company.company_name.partition(" ")[0,5].first
        expect(Giving.company_search(keyword)). to eq([company])
      end
    end
  end

  describe 'associations' do
    it 'responds to user saves' do
      expect(company).to respond_to(:user_saves)
    end
    it 'responds to saved records' do
      expect(company).to respond_to(:saved_records)
    end
  end

end
