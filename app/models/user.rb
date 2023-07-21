class User < ApplicationRecord
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

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
