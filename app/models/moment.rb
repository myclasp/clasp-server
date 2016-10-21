class Moment < ApplicationRecord
  validates :timestamp, presence: true
  validates :identifier, presence: true
  validates :user_id, presence: true
  
  belongs_to :user

  default_scope { order('timestamp') } 

  def self.from(t)
    where("moments.timestamp >= ?", t)
  end

  def self.to(t)
    where("moments.timestamp <= ?", t)
  end

  def has_location?
    return false if (latitude.blank? or longitude.blank?)
    return false if (latitude.eql?(0.0) and longitude.eql?(0.0))
    return true
  end
end
