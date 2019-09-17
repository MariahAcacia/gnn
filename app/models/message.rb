class Message

  include ActiveModel::Model

  attr_accessor :email, :body, :name
  validates :email, :body, :name, presence: true

  def self.send_message(message)
    MessageMailer.contact_me(message).deliver
  end

end
