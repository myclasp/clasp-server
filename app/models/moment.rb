class Moment < ApplicationRecord
  validates :timestamp, presence: true
  validates :identifier, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
end
