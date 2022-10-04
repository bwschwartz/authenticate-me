class User < ApplicationRecord
  has_secure_password
  validates :username,
    uniqueness: true,
    length: { in: 3..30 },
    format: { without: URI::MailTo::EMAIL_REGEXP, message:  "can't be an email" }
  validates :email,
    uniqueness: true,
    length: { in: 3..255 },
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { in: 6..255 }, allow_nil: true

  before_validation :ensure_session_token

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username) #need to include email possibility
    return user&.authenticate(password)
  end

  def generate_unique_session_token
    token = SecureRandom.urlsafe_base64(16)
    while User.find_by(session_token: token)
      token = SecureRandom.urlsafe_base64(16)
    end
    token
  end

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end

  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    return self.session_token
  end
end
