class Moment < ApplicationRecord
  validates :timestamp, presence: true
  validates :identifier, presence: true
  validates :user_id, presence: true
  
  belongs_to :user

  default_scope { order('timestamp') } 

  def self.from(t)
    where("timestamp >= ?", t)
  end

  def self.to(t)
    where("timestamp <= ?", t)
  end
end
