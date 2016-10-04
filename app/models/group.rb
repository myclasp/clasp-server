class Group < ApplicationRecord

  validates :name, presence: true
  serialize :preferences, Hash
  
end
