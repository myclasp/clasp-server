class Moment < ApplicationRecord
  validates :timestamp, presence: true
  validates :identifier, presence: true
end
