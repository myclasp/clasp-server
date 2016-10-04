class Group < ApplicationRecord

  validates :name, presence: true
  serialize :preferences, Hash

  def preferences
    prefs = read_attribute(:preferences)
    
    default = { visualisations: [:line_graph, :map, :calendar, :bar], 
      private: false, data_available: false }
    
    default.each do |key,value|
      prefs[key] = value if prefs[key].nil?
    end
    
    return prefs
  end

end