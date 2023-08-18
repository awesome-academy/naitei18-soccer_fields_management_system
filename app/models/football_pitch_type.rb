class FootballPitchType < ApplicationRecord
  has_many :football_pitches, dependent: :destroy

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :length, :width,
            presence: true,
            numericality: {greater_than: Settings.comparison.number_0}

  scope :newest, ->{order created_at: :desc}
  def self.ransackable_associations _auth_object = nil
    %w(football_pitches)
  end

  def self.ransackable_attributes _auth_object = nil
    %w(id name)
  end
end
