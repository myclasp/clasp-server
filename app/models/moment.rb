require 'csv'

class Moment < ApplicationRecord
  validates :timestamp, presence: true
  validates :identifier, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
  
  belongs_to :user
  has_one :feature, dependent: :destroy

  default_scope { order('timestamp') } 

  def self.from(t)
    where("moments.timestamp >= ?", t)
  end

  def self.to(t)
    where("moments.timestamp <= ?", t)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |moment|
        csv << moment.attributes.values
      end
    end
  end

  def has_location?
    return false if (latitude.blank? or longitude.blank?)
    return false if (latitude.eql?(0.0) and longitude.eql?(0.0))
    return true
  end

  def latlng
    [latitude, longitude]
  end
end
