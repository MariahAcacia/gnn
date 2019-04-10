class User < ApplicationRecord

  has_secure_password

  validates :first_name, :last_name,
                          presence: true,
                          length: { in: 2..20 }
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\w+@\w+\.{1}[a-zA-Z]{2,}/, message: "Must contain @ and ." }

  validates :password,
            length: { in: 7..15 },
            allow_nil: true

  before_create :generate_token


  def generate_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64
    end while User.exists?(:auth_token => self[:auth_token])
  end

  def regenerate_auth_token
    self.auth_token = nil
    generate_token
    save!
  end

end
