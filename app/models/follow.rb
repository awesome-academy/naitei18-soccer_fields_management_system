class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :football_pitch
end
