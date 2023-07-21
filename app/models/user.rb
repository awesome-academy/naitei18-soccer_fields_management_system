class User < ApplicationRecord
  attr_accessor :remember_token

  enum role: {user: 0, admin: 1}
  has_many :bookings, dependent: :destroy
  has_many :football_pitches, through: :bookings

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A
                        (?=.*[a-z])
                        (?=.*[A-Z])
                        (?=.*\d)
                        (?=.*[@$!%*?&])
                        [A-Za-z\d@$!%*?&]{8,}\z
                        /x

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :email,
            presence: true,
            length: {maximum: Settings.digit.length_255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  validates :password,
            presence: true,
            length: {minimum: Settings.digit.length_8},
            format: {with: VALID_PASSWORD_REGEX},
            allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if !remember_token || !remember_digest

    BCrypt::Password.new(remember_digest)
                    .is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end
end
