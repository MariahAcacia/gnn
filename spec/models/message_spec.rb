require 'rails_helper'

describe Message do

  describe 'attributes' do
    it 'responds to email, body, and name' do
      new_msg = Message.new
      expect(new_msg).to respond_to(:name)
      expect(new_msg).to respond_to(:email)
      expect(new_msg).to respond_to(:body)
    end

    it 'is valid when all attributes are set' do
      attrs = { name: 'Bob Burgers',
                email: 'bobby@burgers.com',
                body: 'blah, blah, blah, blah, blah'
              }
      new_msg = Message.new attrs
      expect(new_msg).to be_valid
    end

    it 'does not allow blank name, email or body' do
      new_msg = Message.new
      expect(new_msg).not_to be_valid
      expect(new_msg.errors).not_to be_nil 
    end

  end

end
