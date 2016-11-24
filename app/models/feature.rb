class Feature < ApplicationRecord
  
  serialize :data, Hash
  validates :data, presence: true
  validates :moment_id, presence: true

  belongs_to :moment

  before_save :interpret_data

  def interpret_data
    keys = data["address"].keys
    feature_type = keys - ["road", "neighbourhood", "suburb", "city", "county", "state_district", "state", "postcode", "country", "country_code"]
    feature_type = ["road"] if feature_type.blank?
    self.ftype = feature_type[0] 
    self.name = data["address"][ftype]
  end

  def short_address
    address = data["address"]
    arr = []
    arr << address["road"]
    arr << address["suburb"]
    arr << address["hamlet"]
    arr << address["town"]
    arr << address["city"]
    arr << address["postcode"]
    arr.delete(nil)
    arr.join(", ")
  end
end
