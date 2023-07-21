class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_digest
  attr_accessor :remember_token, :activation_token, :reset_token

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
