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

  has_many :saved_records, dependent: :destroy


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

  def saved_texts
    @texts = []
    @saved_texts = self.saved_records.where(saveable_type: "Text")
    @saved_texts.each do |text|
      @texts << Text.find(text.saveable_id)
    end
    @texts
  end

  def saved_videos
    @videos = []
    @saved_videos = self.saved_records.where(saveable_type: "Video")
    @saved_videos.each do |video|
      @videos << Video.find(video.saveable_id)
    end
  end

  def saved(resource)
    @saved = []
    @records = self.saved_records.where(saveable_type: resource)
    @records.each do |x|
      @saved << resource.constantize.find(x.saveable_id)
    end
    @saved
  end
end
