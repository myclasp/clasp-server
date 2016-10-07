class Group < ApplicationRecord

  validates :name, presence: true
  serialize :preferences, Hash

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def self.default_preferences
    { visualisations: [:line_graph, :map, :calendar, :bar], data_available: false }
  end

  def preferences
    prefs = read_attribute(:preferences)
    
    Group.default_preferences.each do |key,value|
      prefs[key] = value if prefs[key].nil?
    end
    
    return prefs
  end

  def admins
    memberships.where(role: "admin")
  end

  def self.open
    where(is_private: false)
  end

  def moments
    Moment.joins(user: :groups).where('groups.id = ? ', id)
  end

end
