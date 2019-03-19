require 'rails_helper'
require 'factory_bot'

describe User do

  let(:user){ create(:user) }

  it 'is valid with with valid attributes (email, first name, last name, password, password confirmation)' do
    expect(user).to be_valid
  end

  it 'is vaild with valid email (includes @ and .)' do
    new_user = build(:user, email: "bob@burgers.com")
    expect(new_user).to be_valid
  end

  it 'is not valid with invalid email' do
    new_user = build(:user, email: "bobburger.com")
    expect(new_user).not_to be_valid
  end

  it 'is not valid without an email' do
    new_user = build(:user, email: "")
    expect(new_user).not_to be_valid
  end

  it 'is not valid with invalid first name' do
    new_user = build(:user, first_name: "1")
    expect(new_user).not_to be_valid
  end

  it 'is not valid without a first name' do
    new_user = build(:user, first_name: "")
    expect(new_user).not_to be_valid
  end

  it 'is not valid with invalid last name' do
    new_user = build(:user, last_name: "!")
    expect(new_user).not_to be_valid
  end

  it 'is not valid without a last name' do
    new_user = build(:user, last_name: "")
    expect(new_user).not_to be_valid
  end

  it 'is not valid with invalid password' do
    new_user = build(:user, password: "pass")
    expect(new_user).not_to be_valid
  end

  it 'is not valid without a password' do
    new_user = build(:user, password: "")
    expect(new_user).not_to be_valid
  end

  it 'is not valid with invalid password confirmation' do
    new_user = build(:user, password_confirmation: "pass")
    expect(new_user).not_to be_valid
  end

  it 'is not valid without a password confirmation' do
    new_user = build(:user, password_confirmation: "")
    expect(new_user).not_to be_valid
  end

  it 'does not allow identical email addresses' do
    email = "Bob@burgers.com"
    user = create(:user, email: email)
    new_user = build(:user, email: email)
    expect(new_user.valid?).to eq(false)
  end


  describe "associations" do
    it 'responds to saved article associations'
    it 'responds to saved video associations'
    it 'responds to saved spotlight associations'
    it 'responds to saved gygo associations'
  end

end
