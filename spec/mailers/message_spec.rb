require "rails_helper"

RSpec.describe MessageMailer, type: :mailer do
  describe "contact_me" do

    let(:message) { Message.new(email: 'bob@burgers.com',
                                 name: 'Bob Burger',
                                 body: 'Hi, I like or do not like what you are doing here.') }
    let(:mail) { MessageMailer.contact_me(message) }

    it "renders the message" do
      expect(mail.subject).to eq("GNN Message from #{message.name}")
      expect(mail.to).to eq(["mariah.acacia@gmail.com"])
      expect(mail.from).to eq(["#{message.email}"])
      expect(mail.body.encoded).to match(message.body)
    end

  end

end
